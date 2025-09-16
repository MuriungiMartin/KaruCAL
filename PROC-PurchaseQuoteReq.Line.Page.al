#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68032 "PROC-Purchase Quote Req. Line"
{
    PageType = ListPart;
    SourceTable = UnknownTable61052;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        PurchQHeader: Record UnknownRecord61050;
        PParams: Record UnknownRecord61053;


    procedure getLineNo(): Integer
    begin
        exit("Line No.");
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        if "Document No."<>'' then
          begin
            PurchQHeader.Reset;
            PurchQHeader.SetRange(PurchQHeader."Document Type","Document Type");
            PurchQHeader.SetRange(PurchQHeader."No.","No.");
            if PurchQHeader.Status=PurchQHeader.Status::Open then
              begin
                CurrPage.Editable:=true;
              end
            else
              begin
                CurrPage.Editable:=false;
              end;
          end;
    end;
}

