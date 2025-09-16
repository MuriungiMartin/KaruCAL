#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78091 "Student Supp Marks"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Supp Marks.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Semester,"Academic Year",Stage,"School Code",Programme,"Year Of Study";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudentNo_ACACourseRegistration;"ACA-Course Registration"."Student No.")
            {
            }
            column(Semester_ACACourseRegistration;"ACA-Course Registration".Semester)
            {
            }
            column(Programme_ACACourseRegistration;"ACA-Course Registration".Programme)
            {
            }
            column(Stage_ACACourseRegistration;"ACA-Course Registration".Stage)
            {
            }
            column(SettlementType_ACACourseRegistration;"ACA-Course Registration"."Settlement Type")
            {
            }
            column(AcademicYear_ACACourseRegistration;"ACA-Course Registration"."Academic Year")
            {
            }
            column(CompInfoName;CompInfo.Name)
            {
            }
            column(CompInfoEmail;CompInfo."E-Mail")
            {
            }
            column(CompInfoPhoneNo;CompInfo."Phone No.")
            {
            }
            column(CompInfoPicture;CompInfo.Picture)
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(StudName;StudName)
            {
            }
            dataitem(UnknownTable78002;UnknownTable78002)
            {
                DataItemLink = "Student No."=field("Student No."),Semester=field(Semester),Stage=field(Stage);
                DataItemTableView = where(Category=const(Supplementary));
                column(ReportForNavId_1000000013; 1000000013)
                {
                }
                column(AcademicYear_AcaSpecialExamsDetails;"Aca-Special Exams Details"."Academic Year")
                {
                }
                column(UnitDescription_AcaSpecialExamsDetails;"Aca-Special Exams Details"."Unit Description")
                {
                }
                column(ExamMarks_AcaSpecialExamsDetails;"Aca-Special Exams Details"."Exam Marks")
                {
                }
                column(UnitCode_AcaSpecialExamsDetails;"Aca-Special Exams Details"."Unit Code")
                {
                }
                column(Remarks;Remarks)
                {
                }
                column(Score;SuppOne."Exam Marks")
                {
                }
                column(Categ;SuppOne.Category)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Remarks:='';
                    SuppTwo.Reset;
                    SuppTwo.SetRange("Student No.","Student No.");
                    SuppTwo.SetRange(Semester,Semester);
                    SuppTwo.SetRange(SuppTwo."Current Academic Year","Academic Year");
                    SuppTwo.SetRange(Stage,Stage);
                    SuppTwo.SetRange(Category,SuppTwo.Category::Supplementary);
                    SuppTwo.SetRange("Unit Code","Aca-Special Exams Details"."Unit Code");
                    SuppTwo.SetFilter("Exam Marks",'>%1',0);
                    if SuppTwo.FindFirst then
                      Remarks:='Has second Supplementary.';
                end;
            }

            trigger OnAfterGetRecord()
            var
                DoNotSkip: Boolean;
            begin
                foundSupOne:=false;
                foundSupTwo:=false;
                StudName:='';
                ProgName:='';
                SuppOne.Reset;
                SuppOne.SetRange("Student No.","Student No.");
                SuppOne.SetRange(Semester,Semester);
                SuppOne.SetRange(SuppOne."Current Academic Year","Academic Year");
                SuppOne.SetRange(Stage,Stage);
                SuppOne.SetRange(Category,SuppOne.Category::Supplementary);
                // SuppOne.SETAUTOCALCFIELDS("Exam Marks");
                SuppOne.SetFilter("Exam Marks",'>%1',0);
                foundSupOne:=SuppOne.FindFirst;

                SuppTwo.Reset;
                SuppTwo.SetRange("Student No.","Student No.");
                SuppTwo.SetRange(Semester,Semester);
                SuppTwo.SetRange(SuppTwo."Current Academic Year","Academic Year");
                SuppTwo.SetRange(Stage,Stage);
                SuppTwo.SetRange(Category,SuppTwo.Category::Supplementary);
                //SuppTwo.SETAUTOCALCFIELDS("Exam Marks");
                SuppTwo.SetFilter("Exam Marks",'>%1',0);
                foundSupTwo:=SuppTwo.FindFirst;

                DoNotSkip:=foundSupOne or foundSupTwo;

                if not DoNotSkip then
                  CurrReport.Skip;

                Prog.Reset;
                Prog.SetRange(Code,"ACA-Course Registration".Programme);
                if Prog.FindFirst then begin
                  ProgName:=Prog.Description;
                  end;

                Cust.Reset;
                Cust.SetRange("No.","ACA-Course Registration"."Student No.");
                if Cust.FindFirst then begin
                  StudName:=Cust.Name;
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
    end;

    var
        SuppOne: Record UnknownRecord78002;
        SuppTwo: Record UnknownRecord78031;
        foundSupOne: Boolean;
        foundSupTwo: Boolean;
        CompInfo: Record "Company Information";
        ProgName: Text;
        StudName: Text;
        Prog: Record UnknownRecord61511;
        Cust: Record Customer;
        Remarks: Text;
}

