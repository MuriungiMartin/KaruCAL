#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51069 "Entries Reversal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Entries Reversal.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type","Entry No.");
            RequestFilterFields = "Student No.","Settlement Type",Remarks,"Programme Exam Category",Posted;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration__Settlement_Type_;"Settlement Type")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Remarks;Remarks)
            {
            }
            column(Course_RegistrationCaption;Course_RegistrationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Course_Registration_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Course_Registration__Settlement_Type_Caption;FieldCaption("Settlement Type"))
            {
            }
            column(Course_Registration_StageCaption;FieldCaption(Stage))
            {
            }
            column(Course_Registration_RemarksCaption;FieldCaption(Remarks))
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(UnknownTable61535;UnknownTable61535)
            {
                DataItemLink = "Student No."=field("Student No."),"Reg. Transacton ID"=field("Reg. Transacton ID");
                column(ReportForNavId_6235; 6235)
                {
                }
                column(Student_Charges__Reg__Transacton_ID_;"Reg. Transacton ID")
                {
                }
                column(Student_Charges__Transaction_Type_;"Transaction Type")
                {
                }
                column(Student_Charges_Code;Code)
                {
                }
                column(Student_Charges_Description;Description)
                {
                }
                column(Student_Charges_Amount;Amount)
                {
                }
                column(Student_Charges_Transacton_ID;"Transacton ID")
                {
                }
                column(Student_Charges_Student_No_;"Student No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                      "G/LEntry".Reset;
                      "G/LEntry".SetCurrentkey("Document No.","Posting Date");
                      "G/LEntry".SetRange("G/LEntry"."Document No.","ACA-Std Charges"."Transacton ID");
                       if "G/LEntry".Find('-') then begin
                       repeat
                       "G/LEntry".Delete;
                       until "G/LEntry".Next=0;
                       end;

                       CustEntry.Reset;
                       CustEntry.SetCurrentkey("Document No.");
                       CustEntry.SetRange(CustEntry."Document No.","ACA-Std Charges"."Transacton ID");
                       if CustEntry.Find('-') then begin
                       repeat
                       CustEntry.Delete;
                       until CustEntry.Next=0;
                       end;

                       CustDet.Reset;
                       CustDet.SetCurrentkey("Document No.","Posting Date");
                       CustDet.SetRange(CustDet."Document No.","ACA-Std Charges"."Transacton ID");
                       if CustDet.Find('-') then begin
                       repeat
                       CustDet.Delete;
                       until CustDet.Next=0;
                       end;
                end;
            }
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

    var
        "G/LEntry": Record "G/L Entry";
        CustEntry: Record "Cust. Ledger Entry";
        CustDet: Record "Detailed Cust. Ledg. Entry";
        Course_RegistrationCaptionLbl: label 'Course Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

