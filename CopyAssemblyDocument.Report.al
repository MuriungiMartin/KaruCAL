#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 901 "Copy Assembly Document"
{
    Caption = 'Copy Assembly Document';
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
                        OptionCaption = 'Quote,Order,,,Blanket Order,Posted Order';

                        trigger OnValidate()
                        begin
                            DocNo := '';
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
                    }
                    field(IncludeHeader;IncludeHeader)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Header';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DocNo <> '' then
              case DocType of
                Doctype::Quote:
                  if FromAsmHeader.Get(FromAsmHeader."document type"::Quote,DocNo) then;
                Doctype::"Blanket Order":
                  if FromAsmHeader.Get(FromAsmHeader."document type"::"Blanket Order",DocNo) then;
                Doctype::Order:
                  if FromAsmHeader.Get(FromAsmHeader."document type"::Order,DocNo) then;
                Doctype::"Posted Order":
                  if FromPostedAsmHeader.Get(DocNo) then;
              end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        case DocType of
          Doctype::Quote,
          Doctype::Order,
          Doctype::"Blanket Order":
            begin
              FromAsmHeader.Get(DocType,DocNo);
              CopyDocMgt.CopyAsmHeaderToAsmHeader(FromAsmHeader,ToAsmHeader,IncludeHeader);
            end;
          Doctype::"Posted Order":
            begin
              FromPostedAsmHeader.Get(DocNo);
              CopyDocMgt.CopyPostedAsmHeaderToAsmHeader(FromPostedAsmHeader,ToAsmHeader,IncludeHeader);
            end;
        end;
    end;

    var
        FromAsmHeader: Record "Assembly Header";
        FromPostedAsmHeader: Record "Posted Assembly Header";
        ToAsmHeader: Record "Assembly Header";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        DocType: Option Quote,"Order",,,"Blanket Order","Posted Order";
        DocNo: Code[20];
        IncludeHeader: Boolean;

    local procedure LookupDocNo()
    begin
        case DocType of
          Doctype::Quote,
          Doctype::Order,
          Doctype::"Blanket Order":
            begin
              FromAsmHeader.Reset;
              FromAsmHeader.SetRange("Document Type",DocType);
              if DocType = ToAsmHeader."Document Type" then
                FromAsmHeader.SetFilter("No.",'<>%1',ToAsmHeader."No.");
              if Page.RunModal(Page::"Assembly List",FromAsmHeader) = Action::LookupOK then
                DocNo := FromAsmHeader."No.";
            end;
          Doctype::"Posted Order":
            if Page.RunModal(0,FromPostedAsmHeader) = Action::LookupOK then
              DocNo := FromPostedAsmHeader."No.";
        end;
    end;


    procedure SetAssemblyHeader(AsmHeader: Record "Assembly Header")
    begin
        AsmHeader.TestField("No.");
        ToAsmHeader := AsmHeader;
    end;
}

