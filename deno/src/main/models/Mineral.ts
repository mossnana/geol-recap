import {CrystallineStructure} from './CrystallineStructure'

export interface IMineral {
    color: string;
    streak: string;
    crystallineStructure: CrystallineStructure;
    hardness: number;
    cleavage: number;
    fragture: number;
    tenecity: number;
    magnetism: number;
    luster: number;
}

// TODO: Mineral Properties

interface Diaphaneity {}

interface IColor {}

interface IHardness {}

interface ICleavage {}

interface IFracture {}

interface ITenacity {}

interface IMagnetism {}

interface ILuster {}

interface IOdor {}

interface ITaste {}