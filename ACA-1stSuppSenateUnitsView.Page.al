#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66653 "ACA-1st Supp Senate Units View"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable66641;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                    StyleExpr = Suppexists;
                }
                field("Unit Description";"Unit Description")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                    StyleExpr = Suppexists;
                }
                field("Credit Hours";"Credit Hours")
                {
                    ApplicationArea = Basic;
                }
                field("CAT Score";"CAT Score")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Score";"Exam Score")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                    StyleExpr = Suppexists;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Type";"Unit Type")
                {
                    ApplicationArea = Basic;
                }
                field(Pass;Pass)
                {
                    ApplicationArea = Basic;
                }
                field("Weighted Total Score";"Weighted Total Score")
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Category";"Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field("Year of Study";"Year of Study")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Is Supp. Unit";"Is Supp. Unit")
                {
                    ApplicationArea = Basic;
                }
                field("Special Unit Reason";"Special Unit Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Comsolidated Prefix";"Comsolidated Prefix")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Stage";"Unit Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Reporting Academic Year";"Reporting Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Is Special Unit";"Is Special Unit")
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

              Clear(Suppexists);
              Rec.CalcFields("Is Supp. Unit");
              if "Is Supp. Unit" then Suppexists:=true;
    end;

    var
        Suppexists: Boolean;
}

