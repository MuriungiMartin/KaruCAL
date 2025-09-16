#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65252 "Help Desk Issue Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable78012;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Sender ID";"Sender ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Question;Question)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Response;Response)
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
                field("Assigned Personel";"Assigned Personel")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Personel Name";"Assigned Personel Name")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Request Date";"Request Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Status;Status)
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

