#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51298 "Outstanding Imprest"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Outstanding Imprest.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting("Account No.") where("Payment Type"=const(Imprest),Posted=const(Yes),Surrendered=const(No),"Account Type"=const(Customer),Type=const(IMPREST));
            RequestFilterFields = "Account No.",Date,"IW No",Department,"Raised By","Checked By","Approved By";
            column(ReportForNavId_3752; 3752)
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
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments_Payments_No;"FIN-Payments".No)
            {
            }
            column(PFNAME;PFNAME)
            {
            }
            column(Payments__Date_Posted_;"Date Posted")
            {
            }
            column(Payments__IW_No_;"IW No")
            {
            }
            column(Payments__Dept_Name_;"Dept Name")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Purpose;Purpose)
            {
            }
            column(Payments_Amount_Control1102760029;Amount)
            {
            }
            column(Payments_Amount_Control1102760013;Amount)
            {
            }
            column(OUTSTANDING_IMPRESTSCaption;OUTSTANDING_IMPRESTSCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Doc_NoCaption;Doc_NoCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Payments__Date_Posted_Caption;FieldCaption("Date Posted"))
            {
            }
            column(Payments__IW_No_Caption;FieldCaption("IW No"))
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(PurposeCaption;PurposeCaptionLbl)
            {
            }
            column(PF_NOCaption;PF_NOCaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(GRAND_TOTALCaption;GRAND_TOTALCaptionLbl)
            {
            }
            dataitem(UnknownTable61126;UnknownTable61126)
            {
                DataItemLink = No=field(No);
                column(ReportForNavId_3307; 3307)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                    ImpDet.Reset;
                    ImpDet.SetRange(ImpDet.No,"FIN-Payments".No);
                    if ImpDet.Find('-') then begin
                       Purpose:=ImpDet."Account Name";
                    end;
                    PFNAME:="FIN-Payments"."Account Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Account No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        Purpose: Text[100];
        ImpDet: Record UnknownRecord61126;
        PFNAME: Code[150];
        OUTSTANDING_IMPRESTSCaptionLbl: label 'OUTSTANDING IMPRESTS';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Doc_NoCaptionLbl: label 'Doc No';
        NameCaptionLbl: label 'Name';
        DepartmentCaptionLbl: label 'Department';
        PurposeCaptionLbl: label 'Purpose';
        PF_NOCaptionLbl: label 'PF NO';
        TotalsCaptionLbl: label 'Totals';
        GRAND_TOTALCaptionLbl: label 'GRAND TOTAL';
}

