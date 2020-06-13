const router = require('express').Router();
const db = require('../database')
const ADLER32 = require('adler-32')

async function getProjects() {
    let result = await db.any(`
        SELECT *
        FROM public.project
        ORDER BY "createddate" ASC;
    `);
    return result;
}

async function getProjectsByUserId(userid) {
    let result = await db.any(`
        SELECT *
        FROM public.project
        WHERE "createdby" = $1
        ORDER BY "createddate" ASC;
    `, [userid]);
    return result;
}

async function getProjectById(id) {
    let result = await db.one(`
        SELECT *
        FROM public.project
        WHERE "id" = $1;
    `, [id]);
    return result;
}

async function getCheckpoints(sortby) {
    let result;
    if (sortby === 'oldest_to_newest') {
        result = await db.any(`
        SELECT *
        FROM public.checkpoint
        WHERE "source" = 'web'
        ORDER BY "createddate" ASC;`);
    } else {
        result = await db.any(`
        SELECT *
        FROM public.checkpoint
        WHERE "source" = 'web'
        ORDER BY "createddate" DESC;`);
    }
    return result;
}

async function getCheckpointsByProjectId(projectid, sortby) {
    let result;
    if (sortby === 'oldest_to_newest') {
        result = await db.any(`
        SELECT *
        FROM public.checkpoint
        WHERE "projectid" = $1 AND "source" = 'web'
        ORDER BY "createddate" ASC;
        `, [projectid]);
    } else {
        result = await db.any(`
        SELECT *
        FROM public.checkpoint
        WHERE "projectid" = $1 AND "source" = 'web'
        ORDER BY "createddate" DESC;
        `, [projectid]);
    }
    return result;
}

async function getTodayCheckpointsByProjectId(projectid, sortby) {
    let result;
    if (sortby === 'oldest_to_newest') {
        result = await db.any(`
        SELECT *
        FROM public.checkpoint
        WHERE "projectid" = $1 AND "source" = 'web' AND createddate between current_date and current_date + '1 day'::interval
        ORDER BY "createddate" ASC;
        `, [projectid]);
    } else {
        result = await db.any(`
        SELECT *
        FROM public.checkpoint
        WHERE "projectid" = $1 AND "source" = 'web' AND createddate between current_date and current_date + '1 day'::interval
        ORDER BY "createddate" DESC;
        `, [projectid]);
    }
    return result;
}

async function getCheckpointById(id) {
    let result = await db.one(`
        SELECT *
        FROM public.checkpoint
        WHERE "id" = $1;
    `, [id]);
    return result;
}

async function getRocks() {
    let result = await db.any(`
        SELECT *
        FROM public.feature
        WHERE "type" != 'structure'
        ORDER BY "createddate" ASC;
    `);
    return result;
}

async function getRocksByCheckpointId(checkpointid) {
    let result = await db.any(`
        SELECT *
        FROM public.feature
        WHERE "checkpointid" = $1 AND "type" != 'structure'
        ORDER BY "createddate" ASC;
    `, [checkpointid]);
    return result;
}

async function getStructures() {
    let result = await db.any(`
        SELECT *
        FROM public.feature
        WHERE "type" = 'structure'
        ORDER BY "createddate" ASC;
    `);
    return result;
}

async function getStructuresByCheckpointId(checkpointid) {
    let result = await db.any(`
        SELECT *
        FROM public.feature
        WHERE "checkpointid" = $1 AND "type" = 'structure'
        ORDER BY "createddate" ASC;
    `, [checkpointid]);
    return result;
}

// Hello World
router.get("/", async (req, res) => {
    res.send('web route')
});

// Sign in
router.post("/signin", async (req, res) => {
    console.log('Signin')
    let body = req.body;
    let email = body["email"];
    let password = body["password"];
    let result = await db.any(`
          SELECT *
          FROM public."user"
          WHERE email = $1 AND password = $2;
    `, [email, password]);
    if (result.length !== 0) {
        res.send(result[0]);
    } else {
        res.send(false);
    }
});

// Update User
router.post("/user/update", async(req, res) => {
    let body = req.body;
    let id = body["id"];
    let email = body["email"];
    let name = body["name"];
    db.one(`
        UPDATE public.user SET
            name = $1,
            email = $2,
            modifieddate = DEFAULT
        WHERE id = $3 RETURNING *
    `, [name, email, id]
    ).then((result) => {
        res.send(result);
    }).catch(error => {
        res.send({
            message: error
        });
    });
})

// Update Password
router.post("/user/updatepassword", async(req, res) => {
    let body = req.body;
    let id = body['id']
    let password = body['password']
    let currentpassword = body['currentpassword']
    db.one(`
        UPDATE public.user SET
            password = $1,
            modifieddate = DEFAULT
        WHERE id = $2 AND password = $3 RETURNING *
    `, [password, id, currentpassword]
    ).then((result) => {
        res.send(result);
    }).catch(error => {
        console.log(error)
        res.send({
            message: "error"
        });
    });
})

// Sign up
router.post("/signup", async (req, res) => {
    console.log('Sign up')
    let body = req.body;
    let name = body["name"];
    let email = body["email"];
    let password = body["password"];
    let role = body["role"];
    db.one(`
        INSERT INTO public.user(name, email, password, role) VALUES($1, $2, $3, $4)
    `, [name, email, password, role]
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        res.send({
            message: error
        });
    });
});

// Get Projects or Get Projects By User ID
router.get("/projects", async (req, res) => {
    let result;
    let userid = req.query.userid
    if (userid === undefined) {
        result = await getProjects();
    } else {
        result = await getProjectsByUserId(userid);
    }
    if (result.length !== 0) {
        res.send(result);
    } else {
        res.send([]);
    }
});

// Get Projects or Get Projects By User ID
router.get("/project/data/:id", async (req, res) => {
    let result;
    let id = req.params.id
    result = await getProjectById(id);
    res.send(result);
});

// Create Project
router.post("/project/create", async (req, res) => {
    console.log('create project')
    let body = req.body;
    let createdby = parseInt(body['createdby'])
    let code = ADLER32.str(`${createdby}${new Date().getTime()}`);
    db.none(`
        INSERT INTO public.project(
            createdby, modifiedby, code, name, location, description
        ) VALUES ($1, $2, $3, $4, $5, $6)
    `, [createdby, createdby, code, body['name'], body['location'], body['description']]
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        res.send({
            message: error
        });
    });
})

// Edit Project
router.post("/project/update/:id", async (req, res) => {
    console.log('update project')
    let id = parseInt(req.params.id)
    let body = req.body;
    db.none(`
        UPDATE public.project SET
            modifiedby=$1,
            modifieddate=DEFAULT,
            name=$2,
            location=$3,
            description=$4
        WHERE id=$5
    `, [body['modifiedby'], body['name'], body['location'], body['description'], id]
    ).then(() => {
        res.send({
            status: 'success'
        });
    }).catch(error => {
        res.send({
            message: error
        });
    });
})

// Delete Project
router.get("/project/delete/:id", async (req, res) => {
    console.log('update project')
    let id = parseInt(req.params.id)
    db.none("DELETE FROM public.project WHERE id=$1", [id])
        .then(() => {
            res.send({
                message: 'success'
            });
        })
        .catch(error => {
            res.send({
                message: error
            });
        });
})

// Get Checkpoints or Get Checkpoints By Project ID
router.get("/checkpoints", async (req, res) => {
    let result;
    let projectid = req.query.projectid;
    let sortby = req.query.sortby
    if (projectid === undefined) {
        result = await getCheckpoints(sortby);
    } else {
        result = await getCheckpointsByProjectId(projectid, sortby);
    }
    if (result.length !== 0) {
        res.send(result);
    } else {
        res.send([]);
    }
});

// Get Checkpoints Today
router.get("/checkpoints/today", async (req, res) => {
    let result;
    let projectid = req.query.projectid;
    let sortby = req.query.sortby
    result = await getTodayCheckpointsByProjectId(projectid,sortby);
    if (result.length !== 0) {
        res.send(result);
    } else {
        res.send([]);
    }
});

router.get("/checkpoint/data/:id", async (req, res) => {
    let result;
    let id = req.params.id;
    console.log(id)
    result = await getCheckpointById(id);
    
    res.send(result);
});

// Create Checkpoint
router.post("/checkpoint/create", async (req, res) => {
    console.log('create checkpoint')
    let body = req.body;
    let createdby = parseInt(body['createdby'])
    let projectid = parseInt(body['projectid'])
    // Float Numbers Data
    let height = parseFloat(body['height'])
    let width = parseFloat(body['width'])
    let latitude = parseFloat(body['latitude'])
    let longitude = parseFloat(body['longitude'])
    let elevation = parseFloat(body['elevation'])
    let east = parseFloat(body['east'])
    let north = parseFloat(body['north'])
    db.none(`
        insert into public.checkpoint(
            createdby,
            modifiedby,
            projectid,
            name,
            landmark,
            description,
            height,
            width,
            latitude,
            longitude,
            zone,
            elevation,
            east,
            north,
            uploadby,
            source
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
    `, [createdby, createdby, projectid, body['name'], body['landmark'], body['description'], height, width, latitude, longitude, body['zone'], elevation, east, north, ' ', 'web']
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        console.log(error)
        res.send({
            message: error
        });
    });
})

// Edit Checkpoint
router.post("/checkpoint/update/:id", async (req, res) => {
    console.log('update checkpoint')
    let body = req.body;
    let id = parseInt(req.params.id);
    let modifiedby = parseInt(body['modifiedby']);
    // Float Numbers Data
    let height = parseFloat(body['height']);
    let width = parseFloat(body['width']);
    let latitude = parseFloat(body['latitude']);
    let longitude = parseFloat(body['longitude']);
    let elevation = parseFloat(body['elevation']);
    let east = parseFloat(body['east']);
    let north = parseFloat(body['north']);
    db.none(`
        update public.checkpoint set
            modifiedby = $1,
            modifieddate = DEFAULT,
            name = $2,
            landmark = $3,
            description = $4,
            height = $5,
            width = $6,
            latitude = $7,
            longitude = $8,
            zone = $9,
            elevation = $10,
            east = $11,
            north = $12
        where id=$13
    `, [modifiedby, body['name'], body['landmark'], body['description'], height, width, latitude, longitude, body['zone'], elevation, east, north, id]
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        console.log(error)
        res.send({
            message: error
        });
    });
})

// Delete Checkpoint
router.post("/checkpoint/delete/:id", async (req, res) => {
    console.log('delete checkpoint')
    let id = parseInt(req.params.id);
    db.none("DELETE FROM public.checkpoint WHERE id=$1", [id])
        .then(() => {
            res.send({
                message: 'success'
            });
        })
        .catch(error => {
            res.send({
                message: error,
            });
        });
})


// Get Rocks or Get Rocks By Checkpoint ID
router.get("/rocks", async (req, res) => {
    let result;
    let checkpointid = req.query.checkpointid;
    if (checkpointid === undefined) {
        result = await getRocks();
    } else {
        result = await getRocksByCheckpointId(checkpointid);
    }
    if (result.length !== 0) {
        res.send(result);
    } else {
        res.send([]);
    }
});

router.get("/rock/data/:id", async (req, res) => {
    let id = req.params.id;
    let result = await db.one(`
        select * from public."feature" where id = $1
    `, [id]);
    res.send(result)
});


// Create Rock
router.post("/rock/create", async (req, res) => {
    console.log('create rock')
    let body = req.body;
    let createdby = parseInt(body['createdby'])
    let checkpointid = parseInt(body['checkpointid'])
    let code = body["code"];
    let name = body["name"];
    let type = body["type"];
    let lithology = body["lithology"];
    let lithologydescription = body["lithologydescription"];
    let fieldrelation = body["fieldrelation"];
    let fieldrelationdescription = body["fieldrelationdescription"];
    let foliationdescription = body["foliationdescription"];
    let cleavagedescription = body["cleavagedescription"];
    let boudindescription = body["boudindescription"];
    let composition = body["composition"];
    let fossil = body["fossil"];
    let otherfossil = body["otherfossil"];
    let dip = body["dip"];
    let strike = body["strike"];
    let structure = body["structure"];
    let grainsize = body["grainsize"];
    let grainmorphology = body["grainmorphology"];
    let description = body["description"];
    db.none(`
        insert into public.feature (
            createdby, modifiedby, checkpointid, code, name, type, lithology, lithologydescription, fieldrelation, fieldrelationdescription, foliationdescription, cleavagedescription, boudindescription, composition, fossil, otherfossil, dip, strike, plunge, trend, structure, grainsize, grainmorphology, description
        ) values (
            $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24
        );
    `, [createdby, createdby, checkpointid, code, name, type, lithology, lithologydescription, fieldrelation, fieldrelationdescription, foliationdescription, cleavagedescription, boudindescription, composition, fossil, otherfossil, dip, strike, " ", " ", structure, grainsize, grainmorphology, description]
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        console.log(error)
        res.send({
            message: error
        });
    });
})

// Edit Rock
router.post("/rock/update/:id", async (req, res) => {
    console.log('update rocks')
    let body = req.body;
    let id = req.params.id
    let modifiedby = parseInt(body['modifiedby'])
    let code = body["code"];
    let name = body["name"];
    let type = body["type"];
    let lithology = body["lithology"];
    let lithologydescription = body["lithologydescription"];
    let fieldrelation = body["fieldrelation"];
    let fieldrelationdescription = body["fieldrelationdescription"];
    let foliationdescription = body["foliationdescription"];
    let cleavagedescription = body["cleavagedescription"];
    let boudindescription = body["boudindescription"];
    let composition = body["composition"];
    let fossil = body["fossil"];
    let otherfossil = body["otherfossil"];
    let dip = body["dip"];
    let strike = body["strike"];
    let structure = body["structure"];
    let grainsize = body["grainsize"];
    let grainmorphology = body["grainmorphology"];
    let description = body["description"];
    console.log(modifiedby)
    db.none(`
        update public.feature set
            modifiedby = $1,
            modifieddate = DEFAULT,
            code = $2,
            name = $3,
            type = $4,
            lithology = $5,
            lithologydescription = $6,
            fieldrelation = $7,
            fieldrelationdescription = $8,
            foliationdescription = $9,
            cleavagedescription = $10,
            boudindescription = $11,
            composition = $12,
            fossil = $13,
            otherfossil = $14,
            dip = $15,
            strike = $16,
            structure = $17,
            grainsize = $18,
            grainmorphology = $19,
            description = $20
        where id=$21
    `, [modifiedby, code, name, type, lithology, lithologydescription, fieldrelation, fieldrelationdescription, foliationdescription, cleavagedescription, boudindescription, composition, fossil, otherfossil, dip, strike, structure, grainsize, grainmorphology, description, id]
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        console.log(error)
        res.send({
            message: error
        });
    });
})

// Delete Rock
router.post("/rock/delete/:id", async (req, res) => {
    console.log('delete rock')
    let id = req.params.id
    console.log(id)
    db.none("DELETE FROM public.feature WHERE id=$1", [id])
        .then(() => {
            res.send({
                message: 'success'
            });
        })
        .catch(error => {
            console.log(error)
            res.send({
                message: error,
            });
        });
})

// Get Structures or Get Structures By Project ID
router.get("/structures", async (req, res) => {
    let result;
    let checkpointid = req.query.checkpointid;
    if (checkpointid === undefined) {
        result = await getStructures();
    } else {
        result = await getStructuresByCheckpointId(checkpointid);
    }
    if (result.length !== 0) {
        res.send(result);
    } else {
        res.send([]);
    }
});

router.get("/structure/data/:id", async (req, res) => {
    let id = req.params.id;
    let result = await db.one(`
        select * from public."feature" where id = $1
    `, [id]);
    res.send(result)
});

// Create Structure
router.post("/structure/create", async (req, res) => {
    console.log('create structure')
    let body = req.body;
    let createdby = parseInt(body['createdby'])
    let checkpointid = parseInt(body['checkpointid'])
    let code = body["code"];
    let name = body["name"];
    let dip = body["dip"];
    let strike = body["strike"];
    let plunge = body['plunge']
    let trend = body['trend']
    let structure = body["structure"];
    let description = body["description"];
    db.none(`
        insert into public.feature (
            createdby, modifiedby, checkpointid, code, name, type, lithology, lithologydescription, fieldrelation, fieldrelationdescription, foliationdescription, cleavagedescription, boudindescription, composition, fossil, otherfossil, dip, strike, plunge, trend, structure, grainsize, grainmorphology, description
        ) values (
            $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24
        );
    `, [createdby, createdby, checkpointid, code, name, "structure", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", dip, strike, plunge, trend, structure, " ", " ", description]
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        res.send({
            message: error
        });
    });
})

// Edit Structure
router.post("/structure/update/:id", async (req, res) => {
    console.log('update structure')
    let body = req.body;
    let id = req.params.id
    let modifiedby = parseInt(body['modifiedby'])
    let code = body["code"];
    let name = body["name"];
    let dip = body["dip"];
    let strike = body["strike"];
    let structure = body["structure"];
    let plunge = body['plunge']
    let trend = body['trend']
    let description = body["description"];
    db.none(`
        update public.feature set
            modifiedby = $1,
            modifieddate = DEFAULT,
            code = $2,
            name = $3,
            dip = $4,
            strike = $5,
            plunge = $6,
            trend = $7,
            structure = $8,
            description = $9
        where id=$10
    `, [modifiedby, code, name, dip, strike, plunge, trend, structure, description, id]
    ).then(() => {
        res.send({
            message: 'success'
        });
    }).catch(error => {
        res.send({
            message: error
        });
    });
})

// Delete Structure
router.post("/structure/delete/:id", async (req, res) => {
    console.log('delete structure')
    let id = parseInt(req.params.id);
    console.log(id)
    db.none("DELETE FROM public.feature WHERE id=$1", [id])
        .then(() => {
            res.send({
                message: 'success'
            });
        })
        .catch(error => {
            console.log(error)
            res.send({
                message: error,
            });
        });
})

module.exports = router