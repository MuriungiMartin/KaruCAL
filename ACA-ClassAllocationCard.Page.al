#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68412 "ACA-Class Allocation Card"
{
    PageType = Card;
    SourceTable = UnknownTable61212;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("Students Range";"Students Range")
                {
                    ApplicationArea = Basic;
                }
                field("Class Code";"Class Code")
                {
                    ApplicationArea = Basic;
                }
                field("Student Count";"Student Count")
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
            action(Allocate)
            {
                ApplicationArea = Basic;
                Image = Allocate;

                trigger OnAction()
                begin
                      TestField(Programme);
                      TestField(Stage);
                      TestField(Semester);
                      TestField("Class Code");
                      CalcFields("Student Count");
                      if "Student Count"<1 then Error('Zero students found');
                      Creg.Reset;
                      Creg.SetRange(Creg.Programme,Programme);
                      Creg.SetRange(Stage,Creg.Stage);
                      Creg.SetRange(Creg.Semester);
                      Creg.SetFilter(Creg."Student No.","Students Range");
                      if Creg.Find('-') then begin
                      repeat
                      Creg."Class Code":="Class Code";
                      Creg.Modify;
                      until Creg.Next=0;
                      end;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // ERROR('Test');
    end;

    var
        Creg: Record UnknownRecord61532;
}

