#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 89890 "Check Course Registration"
{
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                }
                field(sems;sems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                    TableRelation = "ACA-Semesters".Code;
                }
                field(AcadYear;AcadYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    TableRelation = "ACA-Academic Year".Code;
                }
                field(Prog;Prog)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme';
                    TableRelation = "ACA-Programme".Code;
                }
                field(SettlementType;SettlementType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Settlement Type';
                    TableRelation = "ACA-Settlement Type".Code;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Check Course Registration")
            {
                ApplicationArea = Basic;
                Caption = 'Check Course Registration';
                Image = Aging;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    //MESSAGE(webportals.PreRegisterStudents2("No.",'',sems,Prog,AcadYear,SettlementType));
                end;
            }
        }
    }

    var
        webportals: Codeunit webportals;
        sems: Code[20];
        AcadYear: Code[20];
        Prog: Code[20];
        SettlementType: Code[20];
}

