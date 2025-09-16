#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68991 "HRM-Med. Scheme Members List"
{
    CardPageID = "HRM-Med. Scheme Members Card";
    Editable = true;
    PageType = ListPart;
    SourceTable = "HRM-Medical Scheme Members";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Scheme No";"Scheme No")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Name";"Scheme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Join Date";"Scheme Join Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cumm.Amount Spent";"Cumm.Amount Spent")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cummulative Claims Amount';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Dependants)
            {
                ApplicationArea = Basic;
                Caption = 'Dependants';
                Image = Relatives;
                RunObject = Page "HRM-Medical Dependants List";
                RunPageLink = "Pricipal Member no"=field("Employee No");
            }
        }
    }
}

