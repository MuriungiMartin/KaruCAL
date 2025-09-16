#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 492 "Copy Purchase Document"
{
    Caption = 'Copy Purchase Document';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DocumentType;DocType)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Document Type';
                        OptionCaption = 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Receipt,Posted Invoice,Posted Return Shipment,Posted Credit Memo';
                        ToolTip = 'Specifies the type of document that is processed by the report or batch job.';

                        trigger OnValidate()
                        begin
                            DocNo := '';
                            ValidateDocNo;
                        end;
                    }
                    field(DocumentNo;DocNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            LookupDocNo;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateDocNo;
                        end;
                    }
                    field(BuyfromVendorNo;FromPurchHeader."Buy-from Vendor No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Buy-from Vendor No.';
                        Editable = false;
                        ToolTip = 'Specifies the vendor according to the values in the Document No. and Document Type fields.';
                    }
                    field(BuyfromVendorName;FromPurchHeader."Buy-from Vendor Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Buy-from Vendor Name';
                        Editable = false;
                        ToolTip = 'Specifies the vendor according to the values in the Document No. and Document Type fields.';
                    }
                    field(IncludeHeader_Options;IncludeHeader)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Include Header';
                        ToolTip = 'Specifies if you also want to copy the information from the document header. When you copy quotes, if the posting date field of the new document is empty, the work date is used as the posting date of the new document.';

                        trigger OnValidate()
                        begin
                            ValidateIncludeHeader;
                        end;
                    }
                    field(RecalculateLines;RecalculateLines)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Recalculate Lines';
                        ToolTip = 'Specifies that lines are recalculate and inserted on the purchase document you are creating. The batch job retains the item numbers and item quantities but recalculates the amounts on the lines based on the vendor information on the new document header. In this way, the batch job accounts for item prices and discounts that are specifically linked to the vendor on the new header.';

                        trigger OnValidate()
                        begin
                            if (DocType = Doctype::"Posted Receipt") or (DocType = Doctype::"Posted Return Shipment") then
                              RecalculateLines := true;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DocNo <> '' then begin
              case DocType of
                Doctype::Quote:
                  if FromPurchHeader.Get(FromPurchHeader."document type"::Quote,DocNo) then;
                Doctype::"Blanket Order":
                  if FromPurchHeader.Get(FromPurchHeader."document type"::"Blanket Order",DocNo) then;
                Doctype::Order:
                  if FromPurchHeader.Get(FromPurchHeader."document type"::Order,DocNo) then;
                Doctype::Invoice:
                  if FromPurchHeader.Get(FromPurchHeader."document type"::Invoice,DocNo) then;
                Doctype::"Return Order":
                  if FromPurchHeader.Get(FromPurchHeader."document type"::"Return Order",DocNo) then;
                Doctype::"Credit Memo":
                  if FromPurchHeader.Get(FromPurchHeader."document type"::"Credit Memo",DocNo) then;
                Doctype::"Posted Receipt":
                  if FromPurchRcptHeader.Get(DocNo) then
                    FromPurchHeader.TransferFields(FromPurchRcptHeader);
                Doctype::"Posted Invoice":
                  if FromPurchInvHeader.Get(DocNo) then
                    FromPurchHeader.TransferFields(FromPurchInvHeader);
                Doctype::"Posted Return Shipment":
                  if FromReturnShptHeader.Get(DocNo) then
                    FromPurchHeader.TransferFields(FromReturnShptHeader);
                Doctype::"Posted Credit Memo":
                  if FromPurchCrMemoHeader.Get(DocNo) then
                    FromPurchHeader.TransferFields(FromPurchCrMemoHeader);
              end;
              if FromPurchHeader."No." = '' then
                DocNo := '';
            end;
            ValidateDocNo;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PurchSetup.Get;
        CopyDocMgt.SetProperties(
          IncludeHeader,RecalculateLines,false,false,false,PurchSetup."Exact Cost Reversing Mandatory",false);
        CopyDocMgt.CopyPurchDoc(DocType,DocNo,PurchHeader)
    end;

    var
        PurchHeader: Record "Purchase Header";
        FromPurchHeader: Record "Purchase Header";
        FromPurchRcptHeader: Record "Purch. Rcpt. Header";
        FromPurchInvHeader: Record "Purch. Inv. Header";
        FromReturnShptHeader: Record "Return Shipment Header";
        FromPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchSetup: Record "Purchases & Payables Setup";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        DocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Receipt","Posted Invoice","Posted Return Shipment","Posted Credit Memo";
        DocNo: Code[20];
        IncludeHeader: Boolean;
        RecalculateLines: Boolean;
        Text000: label 'The price information may not be reversed correctly, if you copy a %1. If possible, copy a %2 instead or use %3 functionality.';
        Text001: label 'Undo Receipt';
        Text002: label 'Undo Return Shipment';
        Text003: label 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Receipt,Posted Invoice,Posted Return Shipment,Posted Credit Memo';


    procedure SetPurchHeader(var NewPurchHeader: Record "Purchase Header")
    begin
        NewPurchHeader.TestField("No.");
        PurchHeader := NewPurchHeader;
    end;

    local procedure ValidateDocNo()
    var
        DocType2: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Receipt","Posted Invoice","Posted Return Shipment","Posted Credit Memo";
    begin
        if DocNo = '' then
          FromPurchHeader.Init
        else
          if DocNo <> FromPurchHeader."No." then begin
            FromPurchHeader.Init;
            case DocType of
              Doctype::Quote,
              Doctype::"Blanket Order",
              Doctype::Order,
              Doctype::Invoice,
              Doctype::"Return Order",
              Doctype::"Credit Memo":
                FromPurchHeader.Get(CopyDocMgt.PurchHeaderDocType(DocType),DocNo);
              Doctype::"Posted Receipt":
                begin
                  FromPurchRcptHeader.Get(DocNo);
                  FromPurchHeader.TransferFields(FromPurchRcptHeader);
                  if PurchHeader."Document Type" in
                     [PurchHeader."document type"::"Return Order",PurchHeader."document type"::"Credit Memo"]
                  then begin
                    DocType2 := Doctype2::"Posted Invoice";
                    Message(Text000,SelectStr(1 + DocType,Text003),SelectStr(1 + DocType2,Text003),Text001);
                  end;
                end;
              Doctype::"Posted Invoice":
                begin
                  FromPurchInvHeader.Get(DocNo);
                  FromPurchHeader.TransferFields(FromPurchInvHeader);
                end;
              Doctype::"Posted Return Shipment":
                begin
                  FromReturnShptHeader.Get(DocNo);
                  FromPurchHeader.TransferFields(FromReturnShptHeader);
                  if PurchHeader."Document Type" in
                     [PurchHeader."document type"::Order,PurchHeader."document type"::Invoice]
                  then begin
                    DocType2 := Doctype2::"Posted Credit Memo";
                    Message(Text000,SelectStr(1 + DocType,Text003),SelectStr(1 + DocType2,Text003),Text002);
                  end;
                end;
              Doctype::"Posted Credit Memo":
                begin
                  FromPurchCrMemoHeader.Get(DocNo);
                  FromPurchHeader.TransferFields(FromPurchCrMemoHeader);
                end;
            end;
          end;
        FromPurchHeader."No." := '';

        IncludeHeader :=
          (DocType in [Doctype::"Posted Invoice",Doctype::"Posted Credit Memo"]) and
          ((DocType = Doctype::"Posted Credit Memo") <>
           (PurchHeader."Document Type" = PurchHeader."document type"::"Credit Memo")) and
          (PurchHeader."Buy-from Vendor No." in [FromPurchHeader."Buy-from Vendor No.",'']);
        ValidateIncludeHeader;
    end;

    local procedure LookupDocNo()
    begin
        case DocType of
          Doctype::Quote,
          Doctype::"Blanket Order",
          Doctype::Order,
          Doctype::Invoice,
          Doctype::"Return Order",
          Doctype::"Credit Memo":
            begin
              FromPurchHeader.FilterGroup := 0;
              FromPurchHeader.SetRange("Document Type",CopyDocMgt.PurchHeaderDocType(DocType));
              if PurchHeader."Document Type" = CopyDocMgt.PurchHeaderDocType(DocType) then
                FromPurchHeader.SetFilter("No.",'<>%1',PurchHeader."No.");
              FromPurchHeader.FilterGroup := 2;
              FromPurchHeader."Document Type" := CopyDocMgt.PurchHeaderDocType(DocType);
              FromPurchHeader."No." := DocNo;
              if (DocNo = '') and (PurchHeader."Buy-from Vendor No." <> '') then
                if FromPurchHeader.SetCurrentkey("Document Type","Buy-from Vendor No.") then begin
                  FromPurchHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                  if FromPurchHeader.Find('=><') then;
                end;
              if Page.RunModal(0,FromPurchHeader) = Action::LookupOK then
                DocNo := FromPurchHeader."No.";
            end;
          Doctype::"Posted Receipt":
            begin
              FromPurchRcptHeader."No." := DocNo;
              if (DocNo = '') and (PurchHeader."Buy-from Vendor No." <> '') then
                if FromPurchRcptHeader.SetCurrentkey("Buy-from Vendor No.") then begin
                  FromPurchRcptHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                  if FromPurchRcptHeader.Find('=><') then;
                end;
              if Page.RunModal(0,FromPurchRcptHeader) = Action::LookupOK then
                DocNo := FromPurchRcptHeader."No.";
            end;
          Doctype::"Posted Invoice":
            begin
              FromPurchInvHeader."No." := DocNo;
              if (DocNo = '') and (PurchHeader."Buy-from Vendor No." <> '') then
                if FromPurchInvHeader.SetCurrentkey("Buy-from Vendor No.") then begin
                  FromPurchInvHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                  if FromPurchInvHeader.Find('=><') then;
                end;
              FromPurchInvHeader.FilterGroup(2);
              FromPurchInvHeader.SetRange("Prepayment Invoice",false);
              FromPurchInvHeader.FilterGroup(0);
              if Page.RunModal(0,FromPurchInvHeader) = Action::LookupOK then
                DocNo := FromPurchInvHeader."No.";
            end;
          Doctype::"Posted Return Shipment":
            begin
              FromReturnShptHeader."No." := DocNo;
              if (DocNo = '') and (PurchHeader."Buy-from Vendor No." <> '') then
                if FromReturnShptHeader.SetCurrentkey("Buy-from Vendor No.") then begin
                  FromReturnShptHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                  if FromReturnShptHeader.Find('=><') then;
                end;
              if Page.RunModal(0,FromReturnShptHeader) = Action::LookupOK then
                DocNo := FromReturnShptHeader."No.";
            end;
          Doctype::"Posted Credit Memo":
            begin
              FromPurchCrMemoHeader."No." := DocNo;
              if (DocNo = '') and (PurchHeader."Buy-from Vendor No." <> '') then
                if FromPurchCrMemoHeader.SetCurrentkey("Buy-from Vendor No.") then begin
                  FromPurchCrMemoHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                  if FromPurchCrMemoHeader.Find('=><') then;
                end;
              FromPurchCrMemoHeader.FilterGroup(2);
              FromPurchCrMemoHeader.SetRange("Prepayment Credit Memo",false);
              FromPurchCrMemoHeader.FilterGroup(0);
              if Page.RunModal(0,FromPurchCrMemoHeader) = Action::LookupOK then
                DocNo := FromPurchCrMemoHeader."No.";
            end;
        end;
        ValidateDocNo;
    end;

    local procedure ValidateIncludeHeader()
    begin
        RecalculateLines :=
          (DocType in [Doctype::"Posted Receipt",Doctype::"Posted Return Shipment"]) or not IncludeHeader;
    end;


    procedure InitializeRequest(NewDocType: Option;NewDocNo: Code[20];NewIncludeHeader: Boolean;NewRecalcLines: Boolean)
    begin
        DocType := NewDocType;
        DocNo := NewDocNo;
        IncludeHeader := NewIncludeHeader;
        RecalculateLines := NewRecalcLines;
    end;
}

