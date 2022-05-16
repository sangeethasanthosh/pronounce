import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import dayjs from 'dayjs/esm';

import { DATE_TIME_FORMAT } from 'app/config/input.constants';
import { IPronounce, Pronounce } from '../pronounce.model';

import { PronounceService } from './pronounce.service';

describe('Pronounce Service', () => {
  let service: PronounceService;
  let httpMock: HttpTestingController;
  let elemDefault: IPronounce;
  let expectedResult: IPronounce | IPronounce[] | boolean | null;
  let currentDate: dayjs.Dayjs;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
    });
    expectedResult = null;
    service = TestBed.inject(PronounceService);
    httpMock = TestBed.inject(HttpTestingController);
    currentDate = dayjs();

    elemDefault = {
      id: 0,
      employeeId: 'AAAAAAA',
      firstName: 'AAAAAAA',
      lastName: 'AAAAAAA',
      preferredName: 'AAAAAAA',
      phonetics: 'AAAAAAA',
      country: 'AAAAAAA',
      language: 'AAAAAAA',
      pronoun: 'AAAAAAA',
      pronunciationContentType: 'image/png',
      pronunciation: 'AAAAAAA',
      createdUser: 'AAAAAAA',
      createdDate: currentDate,
      updatedUser: 'AAAAAAA',
      updatedDate: currentDate,
      isActive: false,
    };
  });

  describe('Service methods', () => {
    it('should find an element', () => {
      const returnedFromService = Object.assign(
        {
          createdDate: currentDate.format(DATE_TIME_FORMAT),
          updatedDate: currentDate.format(DATE_TIME_FORMAT),
        },
        elemDefault
      );

      service.find(123).subscribe(resp => (expectedResult = resp.body));

      const req = httpMock.expectOne({ method: 'GET' });
      req.flush(returnedFromService);
      expect(expectedResult).toMatchObject(elemDefault);
    });

    it('should create a Pronounce', () => {
      const returnedFromService = Object.assign(
        {
          id: 0,
          createdDate: currentDate.format(DATE_TIME_FORMAT),
          updatedDate: currentDate.format(DATE_TIME_FORMAT),
        },
        elemDefault
      );

      const expected = Object.assign(
        {
          createdDate: currentDate,
          updatedDate: currentDate,
        },
        returnedFromService
      );

      service.create(new Pronounce()).subscribe(resp => (expectedResult = resp.body));

      const req = httpMock.expectOne({ method: 'POST' });
      req.flush(returnedFromService);
      expect(expectedResult).toMatchObject(expected);
    });

    it('should update a Pronounce', () => {
      const returnedFromService = Object.assign(
        {
          id: 1,
          employeeId: 'BBBBBB',
          firstName: 'BBBBBB',
          lastName: 'BBBBBB',
          preferredName: 'BBBBBB',
          phonetics: 'BBBBBB',
          country: 'BBBBBB',
          language: 'BBBBBB',
          pronoun: 'BBBBBB',
          pronunciation: 'BBBBBB',
          createdUser: 'BBBBBB',
          createdDate: currentDate.format(DATE_TIME_FORMAT),
          updatedUser: 'BBBBBB',
          updatedDate: currentDate.format(DATE_TIME_FORMAT),
          isActive: true,
        },
        elemDefault
      );

      const expected = Object.assign(
        {
          createdDate: currentDate,
          updatedDate: currentDate,
        },
        returnedFromService
      );

      service.update(expected).subscribe(resp => (expectedResult = resp.body));

      const req = httpMock.expectOne({ method: 'PUT' });
      req.flush(returnedFromService);
      expect(expectedResult).toMatchObject(expected);
    });

    it('should partial update a Pronounce', () => {
      const patchObject = Object.assign(
        {
          lastName: 'BBBBBB',
          preferredName: 'BBBBBB',
          phonetics: 'BBBBBB',
          language: 'BBBBBB',
          pronunciation: 'BBBBBB',
          createdDate: currentDate.format(DATE_TIME_FORMAT),
          updatedUser: 'BBBBBB',
          updatedDate: currentDate.format(DATE_TIME_FORMAT),
        },
        new Pronounce()
      );

      const returnedFromService = Object.assign(patchObject, elemDefault);

      const expected = Object.assign(
        {
          createdDate: currentDate,
          updatedDate: currentDate,
        },
        returnedFromService
      );

      service.partialUpdate(patchObject).subscribe(resp => (expectedResult = resp.body));

      const req = httpMock.expectOne({ method: 'PATCH' });
      req.flush(returnedFromService);
      expect(expectedResult).toMatchObject(expected);
    });

    it('should return a list of Pronounce', () => {
      const returnedFromService = Object.assign(
        {
          id: 1,
          employeeId: 'BBBBBB',
          firstName: 'BBBBBB',
          lastName: 'BBBBBB',
          preferredName: 'BBBBBB',
          phonetics: 'BBBBBB',
          country: 'BBBBBB',
          language: 'BBBBBB',
          pronoun: 'BBBBBB',
          pronunciation: 'BBBBBB',
          createdUser: 'BBBBBB',
          createdDate: currentDate.format(DATE_TIME_FORMAT),
          updatedUser: 'BBBBBB',
          updatedDate: currentDate.format(DATE_TIME_FORMAT),
          isActive: true,
        },
        elemDefault
      );

      const expected = Object.assign(
        {
          createdDate: currentDate,
          updatedDate: currentDate,
        },
        returnedFromService
      );

      service.query().subscribe(resp => (expectedResult = resp.body));

      const req = httpMock.expectOne({ method: 'GET' });
      req.flush([returnedFromService]);
      httpMock.verify();
      expect(expectedResult).toContainEqual(expected);
    });

    it('should delete a Pronounce', () => {
      service.delete(123).subscribe(resp => (expectedResult = resp.ok));

      const req = httpMock.expectOne({ method: 'DELETE' });
      req.flush({ status: 200 });
      expect(expectedResult);
    });

    describe('addPronounceToCollectionIfMissing', () => {
      it('should add a Pronounce to an empty array', () => {
        const pronounce: IPronounce = { id: 123 };
        expectedResult = service.addPronounceToCollectionIfMissing([], pronounce);
        expect(expectedResult).toHaveLength(1);
        expect(expectedResult).toContain(pronounce);
      });

      it('should not add a Pronounce to an array that contains it', () => {
        const pronounce: IPronounce = { id: 123 };
        const pronounceCollection: IPronounce[] = [
          {
            ...pronounce,
          },
          { id: 456 },
        ];
        expectedResult = service.addPronounceToCollectionIfMissing(pronounceCollection, pronounce);
        expect(expectedResult).toHaveLength(2);
      });

      it("should add a Pronounce to an array that doesn't contain it", () => {
        const pronounce: IPronounce = { id: 123 };
        const pronounceCollection: IPronounce[] = [{ id: 456 }];
        expectedResult = service.addPronounceToCollectionIfMissing(pronounceCollection, pronounce);
        expect(expectedResult).toHaveLength(2);
        expect(expectedResult).toContain(pronounce);
      });

      it('should add only unique Pronounce to an array', () => {
        const pronounceArray: IPronounce[] = [{ id: 123 }, { id: 456 }, { id: 86673 }];
        const pronounceCollection: IPronounce[] = [{ id: 123 }];
        expectedResult = service.addPronounceToCollectionIfMissing(pronounceCollection, ...pronounceArray);
        expect(expectedResult).toHaveLength(3);
      });

      it('should accept varargs', () => {
        const pronounce: IPronounce = { id: 123 };
        const pronounce2: IPronounce = { id: 456 };
        expectedResult = service.addPronounceToCollectionIfMissing([], pronounce, pronounce2);
        expect(expectedResult).toHaveLength(2);
        expect(expectedResult).toContain(pronounce);
        expect(expectedResult).toContain(pronounce2);
      });

      it('should accept null and undefined values', () => {
        const pronounce: IPronounce = { id: 123 };
        expectedResult = service.addPronounceToCollectionIfMissing([], null, pronounce, undefined);
        expect(expectedResult).toHaveLength(1);
        expect(expectedResult).toContain(pronounce);
      });

      it('should return initial array if no Pronounce is added', () => {
        const pronounceCollection: IPronounce[] = [{ id: 123 }];
        expectedResult = service.addPronounceToCollectionIfMissing(pronounceCollection, undefined, null);
        expect(expectedResult).toEqual(pronounceCollection);
      });
    });
  });

  afterEach(() => {
    httpMock.verify();
  });
});
