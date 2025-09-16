#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65251 "Closed Helpdesk Issues"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable78012;
    SourceTableView = where(Status=filter(Closed));
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
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Report';
                RunObject = Report "HelpDesk Register";
            }
        }
    }
}

