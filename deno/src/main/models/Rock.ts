import { IMineral } from './Mineral'

interface IRock {
    id: number;
    createdDate: Date;
    createdBy: number;
    modifiedBy: Date;
    modifiedDate: number;
    name: String;
    minerals: Array<IMineral>;
}