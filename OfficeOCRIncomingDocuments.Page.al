#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1626 "Office OCR Incoming Documents"
{
    Caption = 'Office Incoming Documents';
    DataCaptionExpression = PageCaptionTxt;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Exchange Object";
    SourceTableTemporary = true;
    SourceTableView = sorting(Name)
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected;Selected)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Send';

                    trigger OnValidate()
                    begin
                        if (IncomingDocumentAttachment."Document No. Filter" <> '') and (Count > 1) and Selected then begin
                          ModifyAll(Selected,false);
                          Selected := true;
                        end;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if Count = 1 then begin
          Selected := true;
          Modify;
        end else
          if IncomingDocumentAttachment."Document No. Filter" <> '' then
            ModifyAll(Selected,false);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        IncomingDocument: Record "Incoming Document";
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then begin
          SetRange(Selected,true);
          if FindSet then begin
            repeat
              case InitiatedAction of
                Initiatedaction::InitiateSendToIncomingDocuments:
                  OfficeMgt.SendToIncomingDocument(Rec,IncomingDocument,IncomingDocumentAttachment);
                Initiatedaction::InitiateSendToOCR:
                  if OfficeMgt.SendToIncomingDocument(Rec,IncomingDocument,IncomingDocumentAttachment) then
                    OfficeMgt.SendToOCR(IncomingDocument);
                Initiatedaction::InitiateSendToWorkFlow:
                  if OfficeMgt.SendToIncomingDocument(Rec,IncomingDocument,IncomingDocumentAttachment) then
                    OfficeMgt.SendApprovalRequest(IncomingDocument);
              end;
            until Next = 0;
            if InitiatedAction = Initiatedaction::InitiateSendToOCR then
              OfficeMgt.DisplayOCRUploadSuccessMessage(Count);
          end;
        end;
    end;

    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        OfficeMgt: Codeunit "Office Management";
        PageCaptionTxt: label 'Select Attachment to Send';


    procedure InitializeIncomingDocumentAttachment(LinkedIncomingDocumentAttachment: Record "Incoming Document Attachment")
    begin
        IncomingDocumentAttachment := LinkedIncomingDocumentAttachment;
    end;


    procedure InitializeExchangeObject(var TempExchangeObject: Record "Exchange Object" temporary)
    begin
        if TempExchangeObject.FindSet then
          repeat
            TempExchangeObject.CalcFields(Content);
            TransferFields(TempExchangeObject);
            Insert;
          until TempExchangeObject.Next = 0;
    end;
}

