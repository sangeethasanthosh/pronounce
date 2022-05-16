import { Component, OnInit } from '@angular/core';
import { HttpResponse } from '@angular/common/http';
import { FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { Observable } from 'rxjs';
import { finalize } from 'rxjs/operators';

import dayjs from 'dayjs/esm';
import { DATE_TIME_FORMAT } from 'app/config/input.constants';

import { IPronounce, Pronounce } from '../pronounce.model';
import { PronounceService } from '../service/pronounce.service';
import { AlertError } from 'app/shared/alert/alert-error.model';
import { EventManager, EventWithContent } from 'app/core/util/event-manager.service';
import { DataUtils, FileLoadError } from 'app/core/util/data-util.service';

@Component({
  selector: 'jhi-pronounce-update',
  templateUrl: './pronounce-update.component.html',
})
export class PronounceUpdateComponent implements OnInit {
  isSaving = false;

  editForm = this.fb.group({
    id: [],
    employeeId: [null, [Validators.required]],
    firstName: [],
    lastName: [],
    preferredName: [],
    phonetics: [],
    country: [],
    language: [],
    pronoun: [],
    pronunciation: [],
    pronunciationContentType: [],
    createdUser: [],
    createdDate: [],
    updatedUser: [],
    updatedDate: [],
    isActive: [],
  });

  constructor(
    protected dataUtils: DataUtils,
    protected eventManager: EventManager,
    protected pronounceService: PronounceService,
    protected activatedRoute: ActivatedRoute,
    protected fb: FormBuilder
  ) {}

  ngOnInit(): void {
    this.activatedRoute.data.subscribe(({ pronounce }) => {
      if (pronounce.id === undefined) {
        const today = dayjs().startOf('day');
        pronounce.createdDate = today;
        pronounce.updatedDate = today;
      }

      this.updateForm(pronounce);
    });
  }

  byteSize(base64String: string): string {
    return this.dataUtils.byteSize(base64String);
  }

  openFile(base64String: string, contentType: string | null | undefined): void {
    this.dataUtils.openFile(base64String, contentType);
  }

  setFileData(event: Event, field: string, isImage: boolean): void {
    this.dataUtils.loadFileToForm(event, this.editForm, field, isImage).subscribe({
      error: (err: FileLoadError) =>
        this.eventManager.broadcast(new EventWithContent<AlertError>('pronounceApp.error', { message: err.message })),
    });
  }

  previousState(): void {
    window.history.back();
  }

  save(): void {
    this.isSaving = true;
    const pronounce = this.createFromForm();
    if (pronounce.id !== undefined) {
      this.subscribeToSaveResponse(this.pronounceService.update(pronounce));
    } else {
      this.subscribeToSaveResponse(this.pronounceService.create(pronounce));
    }
  }

  protected subscribeToSaveResponse(result: Observable<HttpResponse<IPronounce>>): void {
    result.pipe(finalize(() => this.onSaveFinalize())).subscribe({
      next: () => this.onSaveSuccess(),
      error: () => this.onSaveError(),
    });
  }

  protected onSaveSuccess(): void {
    this.previousState();
  }

  protected onSaveError(): void {
    // Api for inheritance.
  }

  protected onSaveFinalize(): void {
    this.isSaving = false;
  }

  protected updateForm(pronounce: IPronounce): void {
    this.editForm.patchValue({
      id: pronounce.id,
      employeeId: pronounce.employeeId,
      firstName: pronounce.firstName,
      lastName: pronounce.lastName,
      preferredName: pronounce.preferredName,
      phonetics: pronounce.phonetics,
      country: pronounce.country,
      language: pronounce.language,
      pronoun: pronounce.pronoun,
      pronunciation: pronounce.pronunciation,
      pronunciationContentType: pronounce.pronunciationContentType,
      createdUser: pronounce.createdUser,
      createdDate: pronounce.createdDate ? pronounce.createdDate.format(DATE_TIME_FORMAT) : null,
      updatedUser: pronounce.updatedUser,
      updatedDate: pronounce.updatedDate ? pronounce.updatedDate.format(DATE_TIME_FORMAT) : null,
      isActive: pronounce.isActive,
    });
  }

  protected createFromForm(): IPronounce {
    return {
      ...new Pronounce(),
      id: this.editForm.get(['id'])!.value,
      employeeId: this.editForm.get(['employeeId'])!.value,
      firstName: this.editForm.get(['firstName'])!.value,
      lastName: this.editForm.get(['lastName'])!.value,
      preferredName: this.editForm.get(['preferredName'])!.value,
      phonetics: this.editForm.get(['phonetics'])!.value,
      country: this.editForm.get(['country'])!.value,
      language: this.editForm.get(['language'])!.value,
      pronoun: this.editForm.get(['pronoun'])!.value,
      pronunciationContentType: this.editForm.get(['pronunciationContentType'])!.value,
      pronunciation: this.editForm.get(['pronunciation'])!.value,
      createdUser: this.editForm.get(['createdUser'])!.value,
      createdDate: this.editForm.get(['createdDate'])!.value
        ? dayjs(this.editForm.get(['createdDate'])!.value, DATE_TIME_FORMAT)
        : undefined,
      updatedUser: this.editForm.get(['updatedUser'])!.value,
      updatedDate: this.editForm.get(['updatedDate'])!.value
        ? dayjs(this.editForm.get(['updatedDate'])!.value, DATE_TIME_FORMAT)
        : undefined,
      isActive: this.editForm.get(['isActive'])!.value,
    };
  }
}
