#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5979 "Copy Service Document"
{
    Caption = 'Copy Service Document';
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
                    field(DocType;DocType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document Type';
                        OptionCaption = 'Quote,Contract';

                        trigger OnValidate()
                        begin
                            DocNo := '';
                            ValidateDocNo;
                        end;
                    }
                    field(DocNo;DocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            LookupDocNo;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateDocNo;
                        end;
                    }
                    field("FromServContractHeader.""Customer No.""";FromServContractHeader."Customer No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer No.';
                        Editable = false;
                    }
                    field("FromServContractHeader.Name";FromServContractHeader.Name)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer Name';
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
            if DocNo <> '' then begin
              case DocType of
                Doctype::Quote:
                  if FromServContractHeader.Get(FromServContractHeader."contract type"::Quote,DocNo) then;
                Doctype::Contract:
                  if FromServContractHeader.Get(FromServContractHeader."contract type"::Contract,DocNo) then;
              end;
              if FromServContractHeader."Contract No." = '' then
                DocNo := ''
              else
                FromServContractHeader.CalcFields(Name);
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Commit;
        if not AllLinesCopied then
          if Confirm(
               Text000,
               true)
          then begin
            OutServContractLine.MarkedOnly := true;
            Page.RunModal(Page::"Service Contract Line List",OutServContractLine);
          end;
    end;

    trigger OnPreReport()
    begin
        if DocNo = '' then
          Error(Text004);
        ValidateDocNo;
        if FromServContractHeader."Ship-to Code" <> ServContractHeader."Ship-to Code" then
          if not Confirm(Text003,false) then
            CurrReport.Quit;
        AllLinesCopied := CopyDocMgt.CopyServContractLines(ServContractHeader,DocType,DocNo,OutServContractLine);
    end;

    var
        ServContractHeader: Record "Service Contract Header";
        FromServContractHeader: Record "Service Contract Header";
        OutServContractLine: Record "Service Contract Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        DocType: Option Quote,Contract;
        DocNo: Code[20];
        AllLinesCopied: Boolean;
        Text000: label 'It was not possible to copy all of the service contract lines.\\Do you want to see these lines?';
        Text002: label 'You can only copy the document with the same %1.';
        Text003: label 'The document has a different ship-to code.\\Do you want to continue?';
        Text004: label 'You must fill in the Document No. field.';


    procedure SetServContractHeader(var NewServContractHeader: Record "Service Contract Header")
    begin
        ServContractHeader := NewServContractHeader;
    end;

    local procedure ValidateDocNo()
    begin
        if DocNo = '' then
          FromServContractHeader.Init
        else begin
          FromServContractHeader.Init;
          FromServContractHeader.Get(DocType,DocNo);
          if FromServContractHeader."Customer No." <> ServContractHeader."Customer No." then
            Error(Text002,ServContractHeader.FieldCaption("Customer No."));
          if FromServContractHeader."Currency Code" <> ServContractHeader."Currency Code" then
            Error(Text002,ServContractHeader.FieldCaption("Currency Code"));
          FromServContractHeader.CalcFields(Name);
        end;
    end;

    local procedure LookupDocNo()
    begin
        FromServContractHeader.FilterGroup := 2;
        FromServContractHeader.SetRange("Contract Type",CopyDocMgt.ServContractHeaderDocType(DocType));
        if ServContractHeader."Contract Type" = CopyDocMgt.ServContractHeaderDocType(DocType) then
          FromServContractHeader.SetFilter("Contract No.",'<>%1',ServContractHeader."Contract No.");
        FromServContractHeader."Contract Type" := CopyDocMgt.ServContractHeaderDocType(DocType);
        FromServContractHeader."Contract No." := DocNo;
        FromServContractHeader.SetCurrentkey("Customer No.","Currency Code","Ship-to Code");
        FromServContractHeader.SetRange("Customer No.",ServContractHeader."Customer No.");
        FromServContractHeader.SetRange("Currency Code",ServContractHeader."Currency Code");
        FromServContractHeader.FilterGroup := 0;
        FromServContractHeader.SetRange("Ship-to Code",ServContractHeader."Ship-to Code");
        if Page.RunModal(0,FromServContractHeader) = Action::LookupOK then
          DocNo := FromServContractHeader."Contract No.";
        ValidateDocNo;
    end;


    procedure InitializeRequest(DocumentType: Option;DocumentNo: Code[20])
    begin
        DocType := DocumentType;
        DocNo := DocumentNo;
    end;
}

