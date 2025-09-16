#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51506 "KCA Receipt Items Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Receipt Items Charges.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Semester_CourseRegistration;"ACA-Course Registration".Semester)
            {
            }
            column(Programme_CourseRegistration;"ACA-Course Registration".Programme)
            {
            }
            column(StudentNo_CourseRegistration;"ACA-Course Registration"."Student No.")
            {
            }
            column(Stage_CourseRegistration;"ACA-Course Registration".Stage)
            {
            }
            column(CustName;CustName)
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(CompanyName;CompInf.Name)
            {
            }
            column(CompInfAddress;CompInf.Address)
            {
            }
            column(CompInfAddress2;CompInf."Address 2")
            {
            }

            trigger OnAfterGetRecord()
            begin
                     if Cust.Get("ACA-Course Registration"."Student No.") then
                     CustName:=Cust.Name;
                     if Prog.Get("ACA-Course Registration".Programme) then
                     ProgName:=Prog.Description;
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

    var
        Receipt_ItemsCaptionLbl: label 'Receipt Items';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_No_CaptionLbl: label 'Student No.';
        Cust: Record Customer;
        CustName: Text[100];
        Prog: Record UnknownRecord61511;
        ProgName: Text[100];
        CompInf: Record "Company Information";
}

