#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5968 "Service Document Registers"
{
    Caption = 'Service Document Registers';
    DataCaptionFields = "Source Document Type","Source Document No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Document Register";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Source Document No.";"Source Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service order or service contract.';
                }
                field("Destination Document Type";"Destination Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document created from the service order or contract specified in the Source Document No.';
                }
                field("Destination Document No.";"Destination Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the invoice or credit memo, based on the contents of the Destination Document Type field.';
                }
                field(CustNo;CustNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bill-To Customer No.';
                    Editable = false;
                    TableRelation = Customer;
                }
                field(CustName;CustName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Name';
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Document")
            {
                Caption = '&Document';
                Image = Document;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        case "Destination Document Type" of
                          "destination document type"::Invoice:
                            begin
                              ServHeader.Get(ServHeader."document type"::Invoice,"Destination Document No.");
                              Page.Run(Page::"Service Invoice",ServHeader);
                            end;
                          "destination document type"::"Credit Memo":
                            begin
                              ServHeader.Get(ServHeader."document type"::"Credit Memo","Destination Document No.");
                              Page.Run(Page::"Service Credit Memo",ServHeader);
                            end;
                          "destination document type"::"Posted Invoice":
                            begin
                              ServInvHeader.Get("Destination Document No.");
                              Page.Run(Page::"Posted Service Invoice",ServInvHeader);
                            end;
                          "destination document type"::"Posted Credit Memo":
                            begin
                              ServCrMemoHeader.Get("Destination Document No.");
                              Page.Run(Page::"Posted Service Credit Memo",ServCrMemoHeader);
                            end;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case "Destination Document Type" of
          "destination document type"::Invoice:
            if ServHeader.Get(ServHeader."document type"::Invoice,"Destination Document No.") then begin
              CustNo := ServHeader."Bill-to Customer No.";
              CustName := ServHeader."Bill-to Name";
            end;
          "destination document type"::"Credit Memo":
            if ServHeader.Get(ServHeader."document type"::"Credit Memo","Destination Document No.") then begin
              CustNo := ServHeader."Bill-to Customer No.";
              CustName := ServHeader."Bill-to Name";
            end;
          "destination document type"::"Posted Invoice":
            if ServInvHeader.Get("Destination Document No.") then begin
              CustNo := ServInvHeader."Bill-to Customer No.";
              CustName := ServInvHeader."Bill-to Name";
            end;
          "destination document type"::"Posted Credit Memo":
            if ServCrMemoHeader.Get("Destination Document No.") then begin
              CustNo := ServCrMemoHeader."Bill-to Customer No.";
              CustName := ServCrMemoHeader."Bill-to Name";
            end;
        end;
    end;

    var
        ServHeader: Record "Service Header";
        ServInvHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        CustNo: Code[20];
        CustName: Text[50];
}

