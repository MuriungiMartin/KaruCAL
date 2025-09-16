#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9092 "Approval FactBox"
{
    Caption = 'Approval';
    PageType = CardPart;
    SourceTable = "Approval Entry";

    layout
    {
        area(content)
        {
            field(DocumentHeading;DocumentHeading)
            {
                ApplicationArea = Basic;
                Caption = 'Document';
            }
            field(Status;Status)
            {
                ApplicationArea = Basic;
            }
            field("Approver ID";"Approver ID")
            {
                ApplicationArea = Basic;
            }
            field("Date-Time Sent for Approval";"Date-Time Sent for Approval")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DocumentHeading := GetDocumentHeading(Rec);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        DocumentHeading := '';

        exit(Find(Which));
    end;

    trigger OnOpenPage()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Copy(Rec);
        if ApprovalEntry.FindFirst then
          SetFilter("Approver ID",'<>%1',ApprovalEntry."Sender ID");
    end;

    var
        DocumentHeading: Text[250];
        Text000: label 'Document';


    procedure GetDocumentHeading(ApprovalEntry: Record "Approval Entry"): Text[50]
    var
        Heading: Text[50];
    begin
        if ApprovalEntry."Document Type" = 0 then
          Heading := Text000
        else
          Heading := Format(ApprovalEntry."Document Type");
        Heading := Heading + ' ' + ApprovalEntry."Document No.";
        exit(Heading);
    end;
}

