#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77785 "Approved Supps List"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable78002;
    SourceTableView = where(Category=const(Supplementary),
                            "Charge Posted"=const(No),
                            Status=filter(Approved));
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
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Description";"Unit Description")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("CAT Marks";"CAT Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Exam Marks";"Exam Marks")
                {
                    ApplicationArea = Basic;
                }
                field("Total Marks";"Total Marks")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Cost Per Exam";"Cost Per Exam")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Current Academic Year";"Current Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Academic Year';
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Semester';
                }
                field("Semester flow";"Semester flow")
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester (Flow)';
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Programme';
                    Editable = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Stage';
                    Editable = false;
                }
                field(Occurances;Occurances)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year Matches";"Academic Year Matches")
                {
                    ApplicationArea = Basic;
                }
                field("Corect Semester Year";"Corect Semester Year")
                {
                    ApplicationArea = Basic;
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea = Basic;
                }
                field("Approved On";"Approved On")
                {
                    ApplicationArea = Basic;
                }
                field("Billed By";"Billed By")
                {
                    ApplicationArea = Basic;
                }
                field("Billed On";"Billed On")
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
            action("Mark As Approved")
            {
                ApplicationArea = Basic;
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    if not Confirm('Do you wish to mark this supplementary booking as approved?\ This action will send the booking to finance for billing.') then
                      exit;
                    Rec.Status:=Rec.Status::Approved;
                    Rec."Approved By":=UserId;
                    Rec."Approved On":=Today;
                    AcaYear.Reset;
                    AcaYear.SetRange("Current Supplementary Year",true);
                    if AcaYear.FindFirst then begin
                      Rec."Current Academic Year":=AcaYear.Code;
                      end;
                    if Rec.Modify then
                      Message('The Supplementary booking has been sent to finance.');

                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange("Approved By",UserId);
    end;

    var
        AcaYear: Record UnknownRecord61382;
}

