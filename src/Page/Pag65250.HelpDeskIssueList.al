#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65250 "Help Desk Issue List"
{
    ApplicationArea = Basic;
    CardPageID = "Help Desk Issue Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable78012;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field("Sender ID";"Sender ID")
                {
                    ApplicationArea = Basic;
                }
                field(Question;Question)
                {
                    ApplicationArea = Basic;
                }
                field(Response;Response)
                {
                    ApplicationArea = Basic;
                }
                field("Request Date";"Request Date")
                {
                    ApplicationArea = Basic;
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Personel";"Assigned Personel")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Personel Name";"Assigned Personel Name")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Resolution Date";"Expected Resolution Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Resolution Time";"Expected Resolution Time")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(MarkAsAssigned)
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Assigned';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TestField("Assigned User ID");
                    TestField(Response);
                    TestField("Expected Resolution Date");
                    TestField("Expected Resolution Time");
                    if Confirm('Mark request as asigned',true)=true then begin
                        Status:=Status::Assigned;
                      Message('Marked as Assigned');

                      end;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Report';
                Image = Register;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "HelpDesk Register";
            }
        }
    }
}

