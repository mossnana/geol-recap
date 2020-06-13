export class CrystallineStructure {
    public nameInEng: string;
    public nameInThai: string;
    public descriptionInEng: string;
    public descriptionInThai: string;

    constructor(
        nameInEng: string,
        nameInThai: string,
        descriptionInEng: string,
        descriptionInThai: string
    ) {
        this.nameInEng = nameInEng;
        this.nameInThai = nameInThai;
        this.descriptionInEng = descriptionInEng;
        this.descriptionInThai = descriptionInThai;
    }
}

export class Euhedral extends CrystallineStructure {
    constructor() {
        super(
            "Euhedral",
            "หน้าสมบูรณ์",
            "well-formed, with sharp, easily recognised faces",
            "ผลึกที่เห็นหน้าผลึกชัดเจนทุกหน้า"
        );
    }
}

export class Subhedral extends CrystallineStructure {
    constructor() {
        super(
            "Subhedral",
            "หน้ากึ่งสมบูรณ์",
            "Between Euhedral and Anhedral",
            "ผลึกที่เห็นหน้าผลึกบางหน้า"
        );
    }
}

export class Anhedral extends CrystallineStructure {
    constructor() {
        super(
            "Anhedral",
            "ไม่ปรากฏหน้าผลึก",
            "well-formed, with sharp, easily recognised faces",
            "ผลึกที่ไม่เห็นหน้าผลึกเลย"
        );
    }
}

export class Microcrystalline extends CrystallineStructure {
    constructor() {
        super(
            "Microcrystalline",
            "ไมโครคริสตัลไลน์",
            "a crystallized substance or rock that contains small crystals visible only through microscopic examination",
            "ผลึกขนาดเล็ก มองด้วยตาเปล่าไม่เห็น ต้องใช้กล้องจุลทรรศน์ในการศึกษา"
        );
    }
}

export class Cryptocrystalline extends CrystallineStructure {
    constructor() {
        super(
            "Cryptocrystalline",
            "คริปโตคริสตัลไลน์",
            "rock's crystalline nature is only vaguely revealed even microscopically",
            "ผลึกหรือกลุ่มผลึกที่มีขนาดเล็กมาก ต้องอาศัยกล้องจุลทรรศน์อิเลคตรอนหรือโดยวิธีทางรังสีเอกซ์มาศึกษา"
        );
    }
}

export class Amorphous extends CrystallineStructure {
    constructor() {
        super(
            "Amorphous",
            "อสัณฐาน",
            "a solid that lacks the long-range order that is characteristic of a crystal",
            "สารซึ่งโครงสร้างภายในไม่เป็นระเบียบ"
        );
    }
}