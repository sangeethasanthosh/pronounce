import { Injectable } from '@angular/core';
import { HttpClient, HttpResponse } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import dayjs from 'dayjs/esm';

import { isPresent } from 'app/core/util/operators';
import { ApplicationConfigService } from 'app/core/config/application-config.service';
import { createRequestOption } from 'app/core/request/request-util';
import { IPronounce, getPronounceIdentifier } from '../pronounce.model';

export type EntityResponseType = HttpResponse<IPronounce>;
export type EntityArrayResponseType = HttpResponse<IPronounce[]>;

@Injectable({ providedIn: 'root' })
export class PronounceService {
  protected resourceUrl = this.applicationConfigService.getEndpointFor('api/pronounces');

  constructor(protected http: HttpClient, protected applicationConfigService: ApplicationConfigService) {}

  create(pronounce: IPronounce): Observable<EntityResponseType> {
    const copy = this.convertDateFromClient(pronounce);
    return this.http
      .post<IPronounce>(this.resourceUrl, copy, { observe: 'response' })
      .pipe(map((res: EntityResponseType) => this.convertDateFromServer(res)));
  }

  update(pronounce: IPronounce): Observable<EntityResponseType> {
    const copy = this.convertDateFromClient(pronounce);
    return this.http
      .put<IPronounce>(`${this.resourceUrl}/${getPronounceIdentifier(pronounce) as number}`, copy, { observe: 'response' })
      .pipe(map((res: EntityResponseType) => this.convertDateFromServer(res)));
  }

  partialUpdate(pronounce: IPronounce): Observable<EntityResponseType> {
    const copy = this.convertDateFromClient(pronounce);
    return this.http
      .patch<IPronounce>(`${this.resourceUrl}/${getPronounceIdentifier(pronounce) as number}`, copy, { observe: 'response' })
      .pipe(map((res: EntityResponseType) => this.convertDateFromServer(res)));
  }

  find(id: number): Observable<EntityResponseType> {
    return this.http
      .get<IPronounce>(`${this.resourceUrl}/${id}`, { observe: 'response' })
      .pipe(map((res: EntityResponseType) => this.convertDateFromServer(res)));
  }

  query(req?: any): Observable<EntityArrayResponseType> {
    const options = createRequestOption(req);
    return this.http
      .get<IPronounce[]>(this.resourceUrl, { params: options, observe: 'response' })
      .pipe(map((res: EntityArrayResponseType) => this.convertDateArrayFromServer(res)));
  }

  delete(id: number): Observable<HttpResponse<{}>> {
    return this.http.delete(`${this.resourceUrl}/${id}`, { observe: 'response' });
  }

  addPronounceToCollectionIfMissing(
    pronounceCollection: IPronounce[],
    ...pronouncesToCheck: (IPronounce | null | undefined)[]
  ): IPronounce[] {
    const pronounces: IPronounce[] = pronouncesToCheck.filter(isPresent);
    if (pronounces.length > 0) {
      const pronounceCollectionIdentifiers = pronounceCollection.map(pronounceItem => getPronounceIdentifier(pronounceItem)!);
      const pronouncesToAdd = pronounces.filter(pronounceItem => {
        const pronounceIdentifier = getPronounceIdentifier(pronounceItem);
        if (pronounceIdentifier == null || pronounceCollectionIdentifiers.includes(pronounceIdentifier)) {
          return false;
        }
        pronounceCollectionIdentifiers.push(pronounceIdentifier);
        return true;
      });
      return [...pronouncesToAdd, ...pronounceCollection];
    }
    return pronounceCollection;
  }

  protected convertDateFromClient(pronounce: IPronounce): IPronounce {
    return Object.assign({}, pronounce, {
      createdDate: pronounce.createdDate?.isValid() ? pronounce.createdDate.toJSON() : undefined,
      updatedDate: pronounce.updatedDate?.isValid() ? pronounce.updatedDate.toJSON() : undefined,
    });
  }

  protected convertDateFromServer(res: EntityResponseType): EntityResponseType {
    if (res.body) {
      res.body.createdDate = res.body.createdDate ? dayjs(res.body.createdDate) : undefined;
      res.body.updatedDate = res.body.updatedDate ? dayjs(res.body.updatedDate) : undefined;
    }
    return res;
  }

  protected convertDateArrayFromServer(res: EntityArrayResponseType): EntityArrayResponseType {
    if (res.body) {
      res.body.forEach((pronounce: IPronounce) => {
        pronounce.createdDate = pronounce.createdDate ? dayjs(pronounce.createdDate) : undefined;
        pronounce.updatedDate = pronounce.updatedDate ? dayjs(pronounce.updatedDate) : undefined;
      });
    }
    return res;
  }
}
