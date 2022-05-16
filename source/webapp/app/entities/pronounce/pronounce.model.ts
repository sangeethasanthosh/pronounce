import dayjs from 'dayjs/esm';

export interface IPronounce {
  id?: number;
  employeeId?: string;
  firstName?: string | null;
  lastName?: string | null;
  preferredName?: string | null;
  phonetics?: string | null;
  country?: string | null;
  language?: string | null;
  pronoun?: string | null;
  pronunciationContentType?: string | null;
  pronunciation?: string | null;
  createdUser?: string | null;
  createdDate?: dayjs.Dayjs | null;
  updatedUser?: string | null;
  updatedDate?: dayjs.Dayjs | null;
  isActive?: boolean | null;
}

export class Pronounce implements IPronounce {
  constructor(
    public id?: number,
    public employeeId?: string,
    public firstName?: string | null,
    public lastName?: string | null,
    public preferredName?: string | null,
    public phonetics?: string | null,
    public country?: string | null,
    public language?: string | null,
    public pronoun?: string | null,
    public pronunciationContentType?: string | null,
    public pronunciation?: string | null,
    public createdUser?: string | null,
    public createdDate?: dayjs.Dayjs | null,
    public updatedUser?: string | null,
    public updatedDate?: dayjs.Dayjs | null,
    public isActive?: boolean | null
  ) {
    this.isActive = this.isActive ?? false;
  }
}

export function getPronounceIdentifier(pronounce: IPronounce): number | undefined {
  return pronounce.id;
}
