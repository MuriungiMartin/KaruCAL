#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78035 "ACA-Posted Graduants"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable78034;
    SourceTableView = where(Posted=filter(Yes));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Year";"Graduation Year")
                {
                    ApplicationArea = Basic;
                }
                field("Certificate Number";"Certificate Number")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Date";"Graduation Date")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print Report';
                Image = PostedReceipts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Print?',true)=false then Error('Cancelled by user!');
                end;
            }
        }
    }

    var
        ACAGraduatedStudentsUpload: Record UnknownRecord78034;
        Customer: Record Customer;
}

