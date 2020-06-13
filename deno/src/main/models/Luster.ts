export interface ILusterProperties {
    name: string;
}

export abstract class Luster implements ILusterProperties {
    name: string;

    constructor(name: string) {
        this.name = name;
    }
}

export class DullLuster extends Luster {}