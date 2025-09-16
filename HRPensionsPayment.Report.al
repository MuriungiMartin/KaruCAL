#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51165 "HR Pensions Payment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Pensions Payment.rdlc';

    dataset
    {
        dataitem(UnknownTable61207;UnknownTable61207)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_HrPensionPayments;"HRM-Pension Payments"."No.")
            {
            }
            column(DateCollected_HrPensionPayments;"HRM-Pension Payments"."Date Collected")
            {
            }
            column(CurrencyCode_HrPensionPayments;"HRM-Pension Payments"."Currency Code")
            {
            }
            column(Payee_HrPensionPayments;"HRM-Pension Payments".Payee)
            {
            }
            column(Specify_HrPensionPayments;"HRM-Pension Payments"."On Behalf Of")
            {
            }
            column(Cashier_HrPensionPayments;"HRM-Pension Payments".Cashier)
            {
            }
            column(Status_HrPensionPayments;"HRM-Pension Payments".Status)
            {
            }
            column(NoSeries_HrPensionPayments;"HRM-Pension Payments"."No. Series")
            {
            }
            column(ChequeNo_HrPensionPayments;"HRM-Pension Payments"."Cheque No.")
            {
            }
            column(PayMode_HrPensionPayments;"HRM-Pension Payments"."Pay Mode")
            {
            }
            column(CollectedBy_HrPensionPayments;"HRM-Pension Payments"."Collected By")
            {
            }
            column(BenefitType_HrPensionPayments;"HRM-Pension Payments"."Benefit Type")
            {
            }
            column(NameofInsurance_HrPensionPayments;"HRM-Pension Payments"."Name of Insurance")
            {
            }
            column(IDNumber_HrPensionPayments;"HRM-Pension Payments"."ID Number")
            {
            }
            column(Amount_HrPensionPayments;"HRM-Pension Payments".Amount)
            {
            }
            column(Principal_HrPensionPayments;"HRM-Pension Payments".Principal)
            {
            }
            column(PrincipalsNames_HrPensionPayments;"HRM-Pension Payments"."Principal's Names")
            {
            }
            column(DatePrepared_HrPensionPayments;"HRM-Pension Payments"."Date Prepared")
            {
            }
            column(CollectedByName_HrPensionPayments;"HRM-Pension Payments"."Collected By (Name)")
            {
            }
            column(EmployeeType_HrPensionPayments;"HRM-Pension Payments"."Employee Type")
            {
            }
            column(no_of_records;NoofRecords)
            {
            }

            trigger OnAfterGetRecord()
            begin
                     NoofRecords:= "HRM-Pension Payments".Count;
                    // message(format(NoofRecords));
            end;
        }
        dataitem("Company Information";"Company Information")
        {
            column(ReportForNavId_1000000020; 1000000020)
            {
            }
            column(Name_CompanyInformation;"Company Information".Name)
            {
            }
            column(Picture_CompanyInformation;"Company Information".Picture)
            {
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

    trigger OnInitReport()
    begin
        NoofRecords:=0;
    end;

    var
        [InDataSet]
        NoofRecords: Integer;
}

