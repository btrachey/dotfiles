// deletes all databases on a mongo server except for 'local', 'admin', and 'config
function deleteDatabases() {
  db = db.getSiblingDB("admin");
  dbs = db.runCommand({"listDatabases": 1}).databases; 
  dbs.forEach(function(database) {
    if (!['local', 'admin', 'config'].includes(database.name)) {
      db = db.getSiblingDB(database.name);
      db.dropDatabase();
    }
  });
}

// update appUser admin to have password of admin again
function resetAdmin(force=false) {
  dbName = db.getName();
  if (dbName.toLowerCase().includes('test') || force) {
    db.appUser.update({"username":"admin"}, {$set: {password: "$2a$10$T16GNp4SxDrtHVDhHdGKoerO8cnczA2puCpc22YAJUixHHo7OlHlG"}});
  } else {
    print("Are you sure you want to set the admin appUser password? It does not look like you are in a test database.");
    print("If you are sure, re-run this command with `true` as the only argument.");
  }
}

// adjusts mongo prompt to display the name of the database and the environment (prd/shd)
function prompt() {
  var database = db.getName();
  try {
    var stage = db.runCommand({serverStatus:1}).security.SSLServerSubjectName.split(",")[2].split("=")[1].split(".")[0];
  } catch (e) {
    var stage = 'local';
  }
  return ` ${database}:${stage} > `
}


// automatically unwraps a DBRef object and, if the lookup collection name is provded, does the lookup. If you want stages before/after this you can do things like:
// db.alert.aggregate([...getDbref('category', 'alertCategory'),...getDbref('alertCategory.group', 'categoryGroup')])
// which will join each alert to it's alert category, then join each category to it's group so you could count alerts by group name. Note that the ellipses are
// critical to make this work - that tells the JS compiler to unwrap the contained array and put each object into the top level array.
function getDbref(fieldName, joinCollName) {
  strippedFieldName = fieldName.replace(/[.]/g, '');
  if (joinCollName===undefined) {
    return [{$addFields:
             {[`${strippedFieldName}Ref`]:
              {$arrayElemAt:
               [{$objectToArray:`\$${fieldName}`},1]
              }
             }
            },
            {$addFields:
             {[`${strippedFieldName}RefID`]:`\$${strippedFieldName}Ref.v`}
            }];
  } else {
    return [{$addFields:
             {[`${strippedFieldName}Ref`]:
              {$arrayElemAt:
               [{$objectToArray:`\$${fieldName}`},1]
              }
             }
            },
            {$addFields:
             {[`${strippedFieldName}RefID`]:`\$${strippedFieldName}Ref.v`}
            },
            {$lookup:
             {
              from: `${joinCollName}`,
              localField: `${strippedFieldName}RefID`,
              foreignField: "_id",
              as: `${strippedFieldName}Lookup`
             }
            },
            {
             $unwind: `\$${strippedFieldName}Lookup`
            }];
  }
}


// override find/findOne to take a single string argument and search by _id
(function() {
  var _findOne = DBCollection.prototype.findOne;
  var _find = DBCollection.prototype.find;
  var _slice = Array.prototype.slice;
  DBCollection.prototype.findOne = function () {
    var args = _slice.call(arguments);
    if (args.length > 0 && (typeof args[0] === "string" || args[0] instanceof ObjectId)) {
      args[0] = {_id: args[0]};
    }
    return _findOne.apply(this, args);
  };
  DBCollection.prototype.find = function () {
    var args = _slice.call(arguments);
    if (args.length > 0 && (typeof args[0] === "string" || args[0] instanceof ObjectId)) {
      args[0] = {_id: args[0]};
    }
    return _find.apply(this, args);
  };
})();


// default cursor size of 10
DBQuery.shellBatchSize = 10;
// default to .pretty()
DBQuery.prototype._prettyShell = true;

// sends a message to slack if the query took longer than 30 seconds
DBQuery.prototype.time = function () {
  var start = new Date()
  var result = this
  if (result.hasNext()) {
    print(result.next())
  }
  var end = new Date()
  if ((end - start)/1000 > 30) {
    run('postToSlack', 
      "Query Complete\n" + "Started: " + start.toString() + '\n' + "Completed: " + end.toString())
  }
  return result
}

