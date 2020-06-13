import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:geolrecap/models/Database.dart';
import 'package:intl/intl.dart';

dynamic getValueOrNull(dynamic value) {
  if(value != null) {
    return value;
  } else {
    return " ";
  }
}

class TableProjectDelegate {
  static Future<List<Map>> get() async {
    final database = await AppDatabase.db.database;
    List<Map> projects = await database.rawQuery('SELECT * FROM project');
    return projects;
  }

  static Future<List<Map<String, dynamic>>> exportRock({int projectId}) async {
    final database = await AppDatabase.db.database;
    List<Map> rocks = await database.rawQuery('''
      SELECT
          CHECKPOINT.*,
          ROCK.*
      FROM rock ROCK
      INNER JOIN checkpoint_feature CF
          ON CF."rockId" = ROCK."id"
      INNER JOIN checkpoint CHECKPOINT
          ON CF."checkpointId" = CHECKPOINT."id"
      WHERE CHECKPOINT."projectId" = $projectId
    ''');
    return rocks;
  }

  static Future<List<Map<String, dynamic>>> exportStructure({int projectId}) async {
    final database = await AppDatabase.db.database;
    List<Map> structures = await database.rawQuery('''
      SELECT
          CHECKPOINT.*,
          STRUCTURE.*
      FROM structure STRUCTURE
      INNER JOIN checkpoint_feature CF
          ON CF."structureId" = STRUCTURE."id"
      INNER JOIN checkpoint CHECKPOINT
          ON CF."checkpointId" = CHECKPOINT."id"
      WHERE CHECKPOINT."projectId" = $projectId
    ''');
    return structures;
  }

  static Future<int> save({String name, String location, String desc, String code}) async {
    final database = await AppDatabase.db.database;
    int projectId = await database.insert('project', {
      'createdDate': DateTime.now().millisecondsSinceEpoch,
      'modifiedDate': DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'location': location,
      'description': desc,
      'code': code,
    });
    return projectId;
  }

  static Future<int> edit(
      {int projectId, String name, String location, String desc, String code}) async {
    final database = await AppDatabase.db.database;
    int updatedId = await database.update('project', {
      'modifiedDate': DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'location': location,
      'description': desc,
      'code': code,
    }, where: 'id = ?', whereArgs: [projectId]);
    return updatedId;
  }

  static Future<int> delete({int id}) async {
    final database = await AppDatabase.db.database;
    List<Map<String, dynamic>> checkpoints = await database.query('checkpoint', where: 'projectId = ?', whereArgs: [id]);
    checkpoints.forEach((checkpoint) async {
      await TableCheckPointDelegate.delete(checkpoint['id']);
    });
    int projectsDeleted = await database.delete('project', where: 'id = ?', whereArgs: [id]);
    return projectsDeleted;
  }

  static Future<bool> exportToWeb({int projectId, String uploadby, String projectCode}) async {
    // get database
    final database = await AppDatabase.db.database;
    // get user id
    final user = await TableUserDelegate.get();
    List checkpoints = [];
    List<Map> queryCheckpoints = await TableCheckPointDelegate.get(projectId: projectId);
    for (var i = 0; i < queryCheckpoints.length; i++) {
      var queryCheckpoint = queryCheckpoints[i];
      var dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');
      var createdDate = dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(queryCheckpoints[i]['createdDate']));
      var modifiedDate = dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(queryCheckpoints[i]['modifiedDate']));
      Map checkpoint = {
        "createddate": createdDate,
        "createdby": user[0]['name'],
        "modifiedby": queryCheckpoint['createdBy'],
        "modifieddate": modifiedDate,
        "projectcode": projectCode,
        "name": getValueOrNull(queryCheckpoint['name']),
        "landmark": getValueOrNull(queryCheckpoint['landmark']),
        "height": queryCheckpoint['height'],
        "width": queryCheckpoint['width'],
        "description": queryCheckpoint['description'],
        "latitude": queryCheckpoint['latitude'],
        "longitude": queryCheckpoint['longitude'],
        "zone": queryCheckpoint['zone'],
        "elevation": queryCheckpoint['elevation'],
        "north": queryCheckpoint['north'],
        "east": queryCheckpoint['east'],
        "uploadby": user.isNotEmpty ? user.first['name'] : "Unknown",
        "source": "mobile",
        "rocks": [],
        "structures": [],
      };
      List<Map> queryRocks = await database.rawQuery('''
        SELECT
            *
        FROM rock ROCK
        INNER JOIN checkpoint_feature CF
            ON CF."rockId" = ROCK."id"
        WHERE CF."checkpointId" = ${queryCheckpoint['id']}
      ''');
      for (var i = 0; i < queryRocks.length; i++) {
        var queryRock = queryRocks[i];
        checkpoint['rocks'].add({
          "id": queryRock['id'],
          "createdby": queryRock['createdBy'],
          "createddate": queryRock['createdDate'],
          "modifiedby": queryRock['modifiedBy'],
          "modifieddate": queryRock['modifiedDate'],
          "code": getValueOrNull(queryRock['code']),
          "name": queryRock['name'],
          "type": queryRock['type'],
          "lithology": getValueOrNull(queryRock['lithology']),
          "lithologydescription": getValueOrNull(queryRock['lithologyDescription']),
          "fieldrelation": getValueOrNull(queryRock['fieldRelation']),
          "fieldrelationdescription": getValueOrNull(queryRock['fieldRelationDescription']),
          "foliationdescription": getValueOrNull(queryRock['foliationDescription']),
          "cleavagedescription": getValueOrNull(queryRock['cleavageDescription']),
          "boudindescription": getValueOrNull(queryRock['boudinDescription']),
          "composition": getValueOrNull(queryRock['composition']),
          "fossil": getValueOrNull(queryRock['fossil']),
          "otherfossil": getValueOrNull(queryRock['otherFossil']),
          "dip": getValueOrNull(queryRock['dip']),
          "strike": getValueOrNull(queryRock['strike']),
          "structure": getValueOrNull(queryRock['structure']),
          "grainsize": getValueOrNull(queryRock['grainSize']),
          "grainmorphology": getValueOrNull(queryRock['grainMorphology']),
          "description": getValueOrNull(queryRock['description']),
        });
      }
      List<Map> queryStructures = await database.rawQuery('''
        SELECT
            *
        FROM structure STRUCTURE
        INNER JOIN checkpoint_feature CF
            ON CF."structureId" = STRUCTURE."id"
        WHERE CF."checkpointId" = ${queryCheckpoint['id']}
      ''');
      for (var i = 0; i < queryStructures.length; i++) {
        var queryStructure = queryStructures[i];
        checkpoint['structures'].add({
          "id": queryStructure['id'],
          "createdby": getValueOrNull(queryStructure['createdBy']),
          "createddate": getValueOrNull(queryStructure['createdDate']),
          "modifiedby": getValueOrNull(queryStructure['modifiedBy']),
          "modifieddate": getValueOrNull(queryStructure['modifiedDate']),
          "code": queryStructure['code'],
          "name": queryStructure['name'],
          "type" : queryStructure['type'],
          "lithology": " ",
          "lithologydescription": " ",
          "fieldrelation": " ",
          "fieldrelationdescription": " ",
          "foliationdescription": " ",
          "cleavagedescription": " ",
          "boudindescription": " ",
          "composition": " ",
          "fossil": " ",
          "otherfossil": " ",
          "lithology": " ",
          "description": queryStructure['description'],
          "dip": queryStructure['dip'],
          "strike": queryStructure['strike'],
          "plunge": queryStructure['plunge'],
          "trend": queryStructure['trend'],
          "grainmorphology": " ",
        });
      }
      checkpoints.add(checkpoint);
    }
    var url = 'http://172.22.22.236:5000/mobile/checkpoints/upload/$projectCode';
    try {
      var result = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(checkpoints),
      );
      print(result);
    } catch(e) {
      print(e);
    }
  }
}

class TableCheckPointDelegate {
  static Future<List<Map>> get({int projectId}) async {
    final database = await AppDatabase.db.database;
    List<Map> checkpoints = await database
        .rawQuery('SELECT * FROM checkpoint WHERE "projectId" = $projectId');
    return checkpoints;
  }

  static Future<Map> getWithImages({int checkpointId}) async {
    final database = await AppDatabase.db.database;
    Map data = {};
    List<Map> checkpoint = await database
        .rawQuery('SELECT * FROM checkpoint WHERE id = $checkpointId');
    data.addAll({'checkpoint': checkpoint[0]});
    if (checkpoint.length == 1) {
      List<String> imageList = [];
      List<Map> images = await database.rawQuery(
          'SELECT path FROM checkpoint_image WHERE checkpointId = $checkpointId');
      for (var i = 0; i < images.length; i++) {
        imageList.add(images[i]['path']);
      }
      data.addAll({'images': imageList});
    }
    return data;
  }

  static Future<int> save(Map json) async {
    final database = await AppDatabase.db.database;
    int checkpointId = await database.rawInsert('''INSERT INTO "checkpoint"(
          createdBy,
          createdDate,
          modifiedBy,
          modifiedDate,
          projectId,
          name,
          landmark,
          description,
          height,
          width,
          latitude,
          longitude,
          zone,
          north,
          east,
          elevation
        ) VALUES (
          ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['projectId'],
      json['name'],
      json['landmark'],
      json['description'],
      json['height'],
      json['width'],
      json['latitude'],
      json['longitude'],
      json['zone'],
      json['north'],
      json['east'],
      json['elevation']
    ]);
    if (json['images'].length != 0) {
      for (var i = 0; i < json['images'].length; i++) {
        File image = json['images'][i];
        int rockImageId = await database.rawInsert('''
        INSERT INTO checkpoint_image (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointId,
          alt,
          path
        ) 
        VALUES (
          ?,?,?,?,?,?,?
        )
        ''', [
          1,
          DateTime.now().millisecondsSinceEpoch,
          1,
          DateTime.now().millisecondsSinceEpoch,
          checkpointId,
          '',
          image.path
        ]);
      }
    }
    return checkpointId;
  }

  static Future<int> edit(Map json) async {
    final database = await AppDatabase.db.database;
    print(json['images']);
    print('wow');
    int updatedCheckpoint = await database.rawUpdate('''
        UPDATE checkpoint
        SET
          modifiedBy = ?,
          modifiedDate = ?,
          name = ?,
          landmark = ?,
          description = ?,
          height = ?,
          width = ?,
          latitude = ?,
          longitude = ?,
          zone = ?,
          north = ?,
          east = ?,
          elevation = ?
        WHERE id = ?
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['name'],
      json['landmark'],
      json['description'],
      json['height'],
      json['width'],
      json['latitude'],
      json['longitude'],
      json['zone'],
      json['north'],
      json['east'],
      json['elevation'],
      json['checkpointId']
    ]);
    await database.rawDelete(
        'DELETE FROM checkpoint_image WHERE checkpointId = ?',
        [json['checkpointId']]);
    if (json['images'].length != 0) {
      for (var i = 0; i < json['images'].length; i++) {
        File image = json['images'][i];
        print('image 11111');
        int rockImageId = await database.rawInsert('''
        INSERT INTO checkpoint_image (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointId,
          alt,
          path
        ) 
        VALUES (
          ?,?,?,?,?,?,?
        )
        ''', [
          1,
          DateTime.now().millisecondsSinceEpoch,
          1,
          DateTime.now().millisecondsSinceEpoch,
          json['checkpointId'],
          '',
          image.path
        ]);
      }
    }
  }

  static Future<int> delete(int id) async {
    final database = await AppDatabase.db.database;
    int rowDeleted = await database.delete('checkpoint', where: 'id = ?', whereArgs: [id]);
    int imageRowsDeleted = await database .delete('checkpoint_image', where: 'checkpointId = ?', whereArgs: [id]);
    return rowDeleted + imageRowsDeleted;
  }
}

class TableNoteDelegate {
  static Future<List<Map>> get() async {
    final database = await AppDatabase.db.database;
    List<Map> notes = await database.rawQuery('SELECT * FROM note');
    return notes;
  }

  static Future<int> save(
      {String title, String content, String keyword}) async {
    final database = await AppDatabase.db.database;
    int projectId = await database.rawInsert('''INSERT INTO note(
          createdBy,
          createdDate,
          modifiedBy,
          modifiedDate,
          title,
          content,
          keyword,
        ) VALUES (
          1,
          ${DateTime.now().millisecondsSinceEpoch},
          1,
          ${DateTime.now().millisecondsSinceEpoch},
          $title,
          \'$content\',
          $keyword,
        )
        ''');
    return projectId;
  }

  static Future<int> delete({int id}) async {
    final database = await AppDatabase.db.database;
    int rowDeleted =
        await database.delete('note', where: 'id = ?', whereArgs: [id]);
    return rowDeleted;
  }

  static Future<int> getDefaultNotes() async {
    final database = await AppDatabase.db.database;
    int test = await database.insert('note', {
      'createdBy': 1,
      'createdDate': DateTime.now().millisecondsSinceEpoch,
      'modifiedBy': 1,
      'modifiedDate': DateTime.now().millisecondsSinceEpoch,
      'title': 'Test Insert',
      'content': '[{"insert":"X","attributes":{"b":true}},{"insert":"\\n","attributes":{"heading":2}},{"insert":"hello\\n"}]',
      'keyword': 'x xx xxx xxxx'
    });
    return test;
  }
}

class TableSedimentaryRockDelegate {
  static Future<int> save(Map json) async {
    final database = await AppDatabase.db.database;
    List imageIds = [];
    int rockId = await database.rawInsert('''
        INSERT INTO rock (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          code, 
          name,
          type,
          lithology,
          fossil,
          otherFossil,
          dip,
          strike,
          structure,
          grainSize,
          grainMorphology,
          description
        ) 
        VALUES (
          ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['code'],
      json['name'],
      'sedimentary',
      json['lithology'],
      json['fossil'],
      json['otherFossil'],
      json['dip'],
      json['strike'],
      json['structure'],
      json['grainSize'],
      json['grainMorphology'],
      json['description']
    ]);
    int checkpointFeatureId = await database.rawInsert('''
        INSERT INTO checkpoint_feature(
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointId,
          rockId
        )
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['checkpointId'],
      rockId,
    ]);
    if (json['images'].length != 0) {
      for (var i = 0; i < json['images'].length; i++) {
        File image = json['images'][i];
        int rockImageId = await database.rawInsert('''
        INSERT INTO feature_image (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointFeature,
          path
        ) 
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
          1,
          DateTime.now().millisecondsSinceEpoch,
          1,
          DateTime.now().millisecondsSinceEpoch,
          checkpointFeatureId,
          image.path
        ]);
        imageIds.add(rockImageId);
      }
    }
    return checkpointFeatureId;
  }

  static Future<int> update(Map json) async {
    final database = await AppDatabase.db.database;
    int count = await database.rawUpdate('''
      update main."rock"
      set
        code = ?,
        name = ?,
        lithology = ?,
        fossil = ?,
        otherFossil = ?,
        dip = ?,
        strike = ?,
        structure = ?,
        grainSize = ?,
        grainMorphology = ?,
        description = ?
      where
        id = ?
    ''', [
      json['code'],
      json['name'],
      json['lithology'],
      json['fossil'],
      json['otherFossil'],
      json['dip'],
      json['strike'],
      json['structure'],
      json['grainSize'],
      json['grainMorphology'],
      json['description'],
      json['rockId'],
    ]);
    int count2 = await database.rawDelete('''
      delete from main."feature_image" where "checkpointFeature" = ?
    ''', [json['featureId']]);
    for (var i = 0; i < json['images'].length; i++) {
      String image = json['images'][i]?.path;
      await database.rawInsert('''
      insert into main."feature_image"(
        checkpointFeature,
        path
      ) values (
        ?,?
      )
    ''', [json['featureId'], image]);
    }
    print('Success');
    return 1;
  }

  static Future<List<Map>> get({int featureId}) async {
    final database = await AppDatabase.db.database;
    List<Map> sedimentaryRocks = await database.rawQuery('''
      SELECT
             C."id" AS checkpointId,
             CF."id" AS featureId,
             CF."rockId" AS rockId,
             R."code" AS code,
             R."name" AS name,
             R."type" AS type,
             R."lithology" AS lithology,
             R."lithologyDescription" AS lithologyDescription,
             R."fieldRelation" AS fieldRelation,
             R."fieldRelationDescription" AS fieldRelationDescription,
             R."foliationDescription" AS foliationDescription,
             R."cleavageDescription" AS cleavageDescription,
             R."boudinDescription" AS boudinDescription,
             R."composition" AS composition,
             R."fossil" AS fossil,
             R."otherFossil" AS otherFossil,
             R."dip" AS dip,
             R."strike" AS strike,
             R."structure" AS structure,
             R."grainSize" AS grainSize,
             R."grainMorphology" AS grainMorphology,
             R."description" AS description
      FROM checkpoint C
      LEFT JOIN checkpoint_feature CF
          on C."id" = CF."checkpointId"
      LEFT JOIN rock R
          ON CF."rockId" = R."id"
      LEFT JOIN feature_image FI
          ON CF."id" = FI."checkpointFeature"
      WHERE R."type" = 'sedimentary' AND CF."id" = ?
    ''', [featureId]);
    return sedimentaryRocks;
  }
}

class TableIgneousRockDelegate {
  static Future<int> save(Map json) async {
    final database = await AppDatabase.db.database;
    List imageIds = [];
    int rockId = await database.rawInsert('''
        INSERT INTO rock (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          code, 
          name,
          type,
          lithology,
          lithologyDescription,
          fieldRelation,
          fieldRelationDescription,
          composition,
          description
        ) 
        VALUES (
          ?,?,?,?,?,?,?,?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['code'],
      json['name'],
      'igneous',
      json['lithology'],
      json['lithologyDescription'],
      json['fieldRelation'],
      json['fieldRelationDescription'],
      json['composition'],
      json['description']
    ]);

    int checkpointFeatureId = await database.rawInsert('''
        INSERT INTO checkpoint_feature(
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointId,
          rockId
        )
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['checkpointId'],
      rockId,
    ]);
    if (json['images'].length != 0) {
      for (var i = 0; i < json['images'].length; i++) {
        File image = json['images'][i];
        int rockImageId = await database.rawInsert('''
        INSERT INTO feature_image (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointFeature,
          path
        ) 
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
          1,
          DateTime.now().millisecondsSinceEpoch,
          1,
          DateTime.now().millisecondsSinceEpoch,
          checkpointFeatureId,
          image.path
        ]);
        imageIds.add(rockImageId);
      }
    }
    return checkpointFeatureId;
  }

  static Future<List<Map>> get({int featureId}) async {
    final database = await AppDatabase.db.database;
    List<Map> igsRocks = await database.rawQuery('''
      SELECT
             C."id" AS checkpointId,
             CF."id" AS featureId,
             CF."rockId" AS rockId,
             R."code" AS code,
             R."name" AS name,
             R."type" AS type,
             R."lithology" AS lithology,
             R."lithologyDescription" AS lithologyDescription,
             R."fieldRelation" AS fieldRelation,
             R."fieldRelationDescription" AS fieldRelationDescription,
             R."foliationDescription" AS foliationDescription,
             R."cleavageDescription" AS cleavageDescription,
             R."boudinDescription" AS boudinDescription,
             R."composition" AS composition,
             R."fossil" AS fossil,
             R."otherFossil" AS otherFossil,
             R."dip" AS dip,
             R."strike" AS strike,
             R."structure" AS structure,
             R."grainSize" AS grainSize,
             R."grainMorphology" AS grainMorphology,
             R."description" AS description
      FROM checkpoint C
      LEFT JOIN checkpoint_feature CF
          on C."id" = CF."checkpointId"
      LEFT JOIN rock R
          ON CF."rockId" = R."id"
      LEFT JOIN feature_image FI
          ON CF."id" = FI."checkpointFeature"
      WHERE R."type" = 'igneous' AND CF."id" = ?
    ''', [featureId]);
    return igsRocks;
  }

  static Future<int> update(Map json) async {
    final database = await AppDatabase.db.database;
    print(json);
    int rockId = await database.rawUpdate('''
        update main."rock"
        set
          modifiedBy = ?, 
          modifiedDate = ?,
          code = ?, 
          name = ?,
          type = ?,
          lithology = ?,
          lithologyDescription = ?,
          fieldRelation = ?,
          fieldRelationDescription = ?,
          composition = ?,
          description = ?
        where id = ?
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['code'],
      json['name'],
      'igneous',
      json['lithology'],
      json['lithologyDescription'],
      json['fieldRelation'],
      json['fieldRelationDescription'],
      json['composition'],
      json['description'],
      json['rockId'],
    ]);
    int count2 = await database.rawDelete('''
      delete from main."feature_image" where "checkpointFeature" = ?
    ''', [json['featureId']]);
    for (var i = 0; i < json['images'].length; i++) {
      String image = json['images'][i]?.path;
      await database.rawInsert('''
      insert into main."feature_image"(
        checkpointFeature,
        path
      ) values (
        ?,?
      )
    ''', [json['featureId'], image]);
    }
    print('Success');
    return 1;
  }
}

class TableMetamorphicRockDelegate {
  static Future<int> save(Map json) async {
    final database = await AppDatabase.db.database;
    List imageIds = [];
    int rockId = await database.rawInsert('''
        INSERT INTO rock (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          code, 
          name,
          type,
          lithologyDescription,
          composition,
          fieldRelationDescription,
          foliationDescription,
          cleavageDescription,
          boudinDescription,
          description
        ) 
        VALUES (
          ?,?,?,?,?,?,?,?,?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['code'],
      json['name'],
      'metamorphic',
      json['lithologyDescription'],
      json['composition'],
      json['fieldRelationDescription'],
      json['foliationDescription'],
      json['cleavageDescription'],
      json['boudinDescription'],
      json['description']
    ]);
    int checkpointFeatureId = await database.rawInsert('''
        INSERT INTO checkpoint_feature(
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointId,
          rockId
        )
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['checkpointId'],
      rockId,
    ]);
    if (json['images'].length != 0) {
      for (var i = 0; i < json['images'].length; i++) {
        File image = json['images'][i];
        int rockImageId = await database.rawInsert('''
        INSERT INTO feature_image (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointFeature,
          path
        ) 
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
          1,
          DateTime.now().millisecondsSinceEpoch,
          1,
          DateTime.now().millisecondsSinceEpoch,
          checkpointFeatureId,
          image.path
        ]);
        imageIds.add(rockImageId);
      }
    }
    return checkpointFeatureId;
  }

  static Future<List<Map>> get({int featureId}) async {
    final database = await AppDatabase.db.database;
    print(featureId);
    print('tracj');
    List<Map> metaRocks = await database.rawQuery('''
      SELECT
             C."id" AS checkpointId,
             CF."id" AS featureId,
             CF."rockId" AS rockId,
             R."code" AS code,
             R."name" AS name,
             R."type" AS type,
             R."lithology" AS lithology,
             R."lithologyDescription" AS lithologyDescription,
             R."fieldRelation" AS fieldRelation,
             R."fieldRelationDescription" AS fieldRelationDescription,
             R."foliationDescription" AS foliationDescription,
             R."cleavageDescription" AS cleavageDescription,
             R."boudinDescription" AS boudinDescription,
             R."composition" AS composition,
             R."fossil" AS fossil,
             R."otherFossil" AS otherFossil,
             R."dip" AS dip,
             R."strike" AS strike,
             R."structure" AS structure,
             R."grainSize" AS grainSize,
             R."grainMorphology" AS grainMorphology,
             R."description" AS description
      FROM checkpoint C
      LEFT JOIN checkpoint_feature CF
          on C."id" = CF."checkpointId"
      LEFT JOIN rock R
          ON CF."rockId" = R."id"
      LEFT JOIN feature_image FI
          ON CF."id" = FI."checkpointFeature"
      WHERE R."type" = 'metamorphic' AND CF."id" = ?
    ''', [featureId]);
    return metaRocks;
  }

  static Future<int> update(Map json) async {
    final database = await AppDatabase.db.database;
    print(json);
    int rockId = await database.rawUpdate('''
        update main."rock"
        set
          modifiedBy = ?, 
          modifiedDate = ?,
          code = ?, 
          name = ?,
          type = ?,
          lithologyDescription = ?,
          composition = ?,
          fieldRelationDescription = ?,
          foliationDescription = ?,
          cleavageDescription = ?,
          boudinDescription = ?,
          description = ?
        where id = ?
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['code'],
      json['name'],
      'metamorphic',
      json['lithologyDescription'],
      json['composition'],
      json['fieldRelationDescription'],
      json['foliationDescription'],
      json['cleavageDescription'],
      json['boudinDescription'],
      json['description'],
      json['rockId'],
    ]);
    int count2 = await database.rawDelete('''
      delete from main."feature_image" where "checkpointFeature" = ?
    ''', [json['featureId']]);
    for (var i = 0; i < json['images'].length; i++) {
      String image = json['images'][i]?.path;
      await database.rawInsert('''
      insert into main."feature_image"(
        checkpointFeature,
        path
      ) values (
        ?,?
      )
    ''', [json['featureId'], image]);
    }
    print('Success');
    return 1;
  }
}

class TableStructureDelegate {
  static Future<int> save(Map json) async {
    final database = await AppDatabase.db.database;
    List imageIds = [];
    int structureId = await database.rawInsert('''
        INSERT INTO structure (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          code, 
          name,
          type,
          description,
          dip,
          strike,
          plunge,
          trend
        ) 
        VALUES (
          ?,?,?,?,?,?,?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['code'],
      json['name'],
      json['type'],
      json['description'],
      json['dip'],
      json['strike'],
      json['plunge'],
      json['trend']
    ]);
    int checkpointFeatureId = await database.rawInsert('''
        INSERT INTO checkpoint_feature(
          createdBy,
          createdDate,
          modifiedBy,
          modifiedDate,
          checkpointId,
          structureId
        )
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['checkpointId'],
      structureId,
    ]);
    if (json['images'].length != 0) {
      for (var i = 0; i < json['images'].length; i++) {
        File image = json['images'][i];
        int rockImageId = await database.rawInsert('''
        INSERT INTO feature_image (
          createdBy, 
          createdDate, 
          modifiedBy, 
          modifiedDate,
          checkpointFeature,
          path
        ) 
        VALUES (
          ?,?,?,?,?,?
        )
        ''', [
          1,
          DateTime.now().millisecondsSinceEpoch,
          1,
          DateTime.now().millisecondsSinceEpoch,
          checkpointFeatureId,
          image.path
        ]);
        imageIds.add(rockImageId);
      }
    }
    return checkpointFeatureId;
  }

  static Future<List<Map>> get({int featureId}) async {
    final database = await AppDatabase.db.database;
    List<Map> structures = await database.rawQuery('''
      SELECT
             C."id" AS checkpointId,
             CF."id" AS featureId,
             CF."structureId" AS structureId,
             S."code" AS code,
             S."name" AS name,
             S."type" AS type,
             S."dip" AS dip,
             S."strike" AS strike,
             S."plunge" AS plunge,
             S."trend" AS trend,
             S."description" AS description
      FROM checkpoint C
      LEFT JOIN checkpoint_feature CF
          on C."id" = CF."checkpointId"
      LEFT JOIN structure S
          ON CF."structureId" = S."id"
      LEFT JOIN feature_image FI
          ON CF."id" = FI."checkpointFeature"
      WHERE CF."id" = ?
    ''', [featureId]);
    return structures;
  }

  static Future<int> update(Map json) async {
    final database = await AppDatabase.db.database;
    print(json);
    int structureId = await database.rawUpdate('''
        update main."structure"
        set
          modifiedBy = ?, 
          modifiedDate = ?,
          code = ?, 
          name = ?,
          type = ?,
          description = ?,
          dip = ?,
          strike = ?,
          plunge = ?,
          trend = ?
        where id = ?
        ''', [
      1,
      DateTime.now().millisecondsSinceEpoch,
      json['code'],
      json['name'],
      json['type'],
      json['description'],
      json['dip'],
      json['strike'],
      json['plunge'],
      json['trend'],
      json['structureId'],
    ]);
    int count2 = await database.rawDelete('''
      delete from main."feature_image" where "checkpointFeature" = ?
    ''', [json['featureId']]);
    for (var i = 0; i < json['images'].length; i++) {
      String image = json['images'][i]?.path;
      await database.rawInsert('''
      insert into main."feature_image"(
        checkpointFeature,
        path
      ) values (
        ?,?
      )
    ''', [json['featureId'], image]);
    }
    print('Success');
    return 1;
  }
}

class TableFeatureDelegate {
  static Future<List> get(int checkpointId) async {
    List features = [];
    final database = await AppDatabase.db.database;
    List<Map> rockFeatures = await database.rawQuery('''
      SELECT
           C."id" AS checkpointId,
           CF."id" AS featureId,
           R."type" AS type,
           R."name" AS name,
           R."createdDate" AS date,
           CF."modifiedDate" AS modifiedDate
      FROM checkpoint_feature CF
      LEFT JOIN checkpoint C
        ON C."id" = CF."checkpointId"
      LEFT JOIN rock R
        ON R."id" = CF."rockId"
      WHERE C."id" = $checkpointId AND CF."structureId" IS NULL
    ''');
    rockFeatures.forEach((each) => features.add(each));
    List<Map> structureFeatures = await database.rawQuery('''
      SELECT
           C."id" AS checkpointId,
           CF."id" AS featureId,
           S."name" AS name,
           S."createdDate" AS date,
           CF."modifiedDate" AS modifiedDate
      FROM checkpoint_feature CF
      LEFT JOIN checkpoint C
        ON C."id" = CF."checkpointId"
      LEFT JOIN structure S
        ON S."id" = CF."structureId"
      WHERE C."id" = $checkpointId AND CF."rockId" IS NULL
    ''');
    structureFeatures.forEach((each) => features.add(each));
    return features;
  }

  static Future<List<File>> getImages(int featureId) async {
    final database = await AppDatabase.db.database;
    List<Map> images = await database.rawQuery(
        'SELECT path FROM feature_image WHERE checkpointFeature = $featureId');
    List<File> returnImages = [];
    for (var i = 0; i < images.length; i++) {
      File image = new File(images[i]['path']);
      returnImages.add(image);
    }
    return returnImages;
  }

  static Future<int> deleteRock(Map rock) async {
    final database = await AppDatabase.db.database;
    int deleteImageRows = await database.delete('feature_image',
        where: 'checkpointFeature = ?', whereArgs: [rock['featureId']]);
    int deleteRockRows = await database
        .delete('rock', where: 'id = ?', whereArgs: [rock['rockId']]);
    int deleteSelfRows = await database.delete('checkpoint_feature',
        where: 'rockId = ?', whereArgs: [rock['rockId']]);
    return deleteImageRows + deleteRockRows + deleteSelfRows;
  }

  static Future<int> deleteStructure(Map structure) async {
    final database = await AppDatabase.db.database;
    int deleteImageRows = await database.delete('feature_image',
        where: 'checkpointFeature = ?', whereArgs: [structure['featureId']]);
    int deleteStructureRows = await database.delete('structure',
        where: 'id = ?', whereArgs: [structure['structureId']]);
    int deleteSelfRows = await database.delete('checkpoint_feature',
        where: 'structureId = ?', whereArgs: [structure['structureId']]);
    return deleteImageRows + deleteStructureRows + deleteSelfRows;
  }

  static String typeToString(String type) {
    if (type == 'sedimentary') {
      return 'Sedimentary Rock';
    } else if (type == 'metamorphic') {
      return 'Metamorphic Rock';
    } else if (type == 'igneous') {
      return 'Igneous Rock';
    } else {
      return 'Structure';
    }
  }
}

class TableUserDelegate {
  static Future<List<Map>> get() async {
    final database = await AppDatabase.db.database;
    List<Map> user = await database.rawQuery('SELECT * FROM user LIMIT 1');
    return user;
  }

  static Future<int> save(Map json) async {
    final database = await AppDatabase.db.database;
    List<Map> user = await database.rawQuery('SELECT * FROM user LIMIT 1');
    var result;
    if (user.length > 0) {
      result = await database.rawUpdate(
          'UPDATE user SET name = ?, role = ? WHERE id = 1;',
          [json['name'], json['role']]);
    } else {
      result = await database.rawInsert(
          'INSERT INTO user(name, role) values (?, ?)',
          [json['name'], json['role']]);
    }
    return result;
  }
}
