#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51403 "Process Student Patients"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Process Student Patients.rdlc';

    dataset
    {
        dataitem(UnknownTable61372;UnknownTable61372)
        {
            DataItemTableView = sorting("Admission No.");
            RequestFilterFields = "Admission No.";
            column(ReportForNavId_3773; 3773)
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
            column(Admission_Form_Header__Admission_No__;"Admission No.")
            {
            }
            column(Admission_Form_Header__Admission_No___Control1102760011;"Admission No.")
            {
            }
            column(Admission_Form_Header_Date;Date)
            {
            }
            column(Admission_Form_Header__Admission_Type_;"Admission Type")
            {
            }
            column(Admission_Form_Header__JAB_S_No_;"JAB S.No")
            {
            }
            column(Admission_Form_Header__Academic_Year_;"Academic Year")
            {
            }
            column(Admission_Form_Header__Application_No__;"Application No.")
            {
            }
            column(Admission_Form_Header_Surname;Surname)
            {
            }
            column(Admission_Form_Header__Other_Names_;"Other Names")
            {
            }
            column(Admission_Form_Header__Faculty_Admitted_To_;"Faculty Admitted To")
            {
            }
            column(Admission_Form_Header__Degree_Admitted_To_;"Degree Admitted To")
            {
            }
            column(Admission_Form_Header__Date_Of_Birth_;"Date Of Birth")
            {
            }
            column(Admission_Form_Header_Gender;Gender)
            {
            }
            column(Admission_Form_Header__Marital_Status_;"Marital Status")
            {
            }
            column(Admission_Form_HeaderCaption;Admission_Form_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Admission_Form_Header__Admission_No___Control1102760011Caption;FieldCaption("Admission No."))
            {
            }
            column(Admission_Form_Header_DateCaption;FieldCaption(Date))
            {
            }
            column(Admission_Form_Header__Admission_Type_Caption;FieldCaption("Admission Type"))
            {
            }
            column(Admission_Form_Header__JAB_S_No_Caption;FieldCaption("JAB S.No"))
            {
            }
            column(Admission_Form_Header__Academic_Year_Caption;FieldCaption("Academic Year"))
            {
            }
            column(Admission_Form_Header__Application_No__Caption;FieldCaption("Application No."))
            {
            }
            column(Admission_Form_Header_SurnameCaption;FieldCaption(Surname))
            {
            }
            column(Admission_Form_Header__Other_Names_Caption;FieldCaption("Other Names"))
            {
            }
            column(Admission_Form_Header__Faculty_Admitted_To_Caption;FieldCaption("Faculty Admitted To"))
            {
            }
            column(Admission_Form_Header__Degree_Admitted_To_Caption;FieldCaption("Degree Admitted To"))
            {
            }
            column(Admission_Form_Header__Date_Of_Birth_Caption;FieldCaption("Date Of Birth"))
            {
            }
            column(Admission_Form_Header_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Admission_Form_Header__Marital_Status_Caption;FieldCaption("Marital Status"))
            {
            }
            column(Admission_Form_Header__Admission_No__Caption;FieldCaption("Admission No."))
            {
            }

            trigger OnAfterGetRecord()
            begin
                HMSPatient.CopyStudentToHMS("ACA-Adm. Form Header");
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Admission No.");
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
        Customer.Reset;
        Customer.SetRange(Customer."Customer Type",Customer."customer type"::Student);
        if Customer.Find('-') then
          begin
            repeat
              HMSPatient.CopyRegisteredStudentToHMS(Customer);
            until Customer.Next=0;
          end;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        HMSPatient: Codeunit "HMS Patient";
        Customer: Record Customer;
        Admission_Form_HeaderCaptionLbl: label 'Admission Form Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

