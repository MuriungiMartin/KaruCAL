#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51015 "Student Proforma Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Proforma Invoice.rdlc';

    dataset
    {
        dataitem(UnknownTable61523;UnknownTable61523)
        {
            RequestFilterFields = "Programme Code","Stage Code","Settlemet Type",Semester;
            column(ReportForNavId_2453; 2453)
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
            column(TuitionTT;"Break Down")
            {
            }
            column(Fee_By_StageCaption;Fee_By_StageCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Tuition_PayableCaption;Tuition_PayableCaptionLbl)
            {
            }
            column(Fee_By_Stage_Programme_Code;"Programme Code")
            {
            }
            column(Fee_By_Stage_Stage_Code;"Stage Code")
            {
            }
            column(Fee_By_Stage_Semester;Semester)
            {
            }
            column(Fee_By_Stage_Student_Type;"Student Type")
            {
            }
            column(Fee_By_Stage_Settlemet_Type;"Settlemet Type")
            {
            }
            column(Fee_By_Stage_Seq_;"Seq.")
            {
            }
            column(ProgName;"ACA-Fee By Stage"."Programme Description")
            {
            }
            column(StageName;"ACA-Fee By Stage"."Stage Description")
            {
            }
            column(Total;TotalAmount)
            {
            }
            dataitem(UnknownTable61533;UnknownTable61533)
            {
                DataItemLink = "Programme Code"=field("Programme Code"),"Stage Code"=field("Stage Code"),"Settlement Type"=field("Settlemet Type");
                column(ReportForNavId_6690; 6690)
                {
                }
                column(Stage_Charges_Code;Code)
                {
                }
                column(Stage_Charges_Description;Description)
                {
                }
                column(Stage_Charges_Amount;Amount)
                {
                }
                column(Fee_By_Stage___Break_Down___Stage_Charges__Amount;"ACA-Stage Charges".Amount+TuitionAmount)
                {
                }
                column(Stage_Charges_Programme_Code;"Programme Code")
                {
                }
                column(Stage_Charges_Stage_Code;"Stage Code")
                {
                }
                column(Stage_Charges_Settlement_Type;"Settlement Type")
                {
                }
                column(Stage_Charges_Semester;Semester)
                {
                }
                column(Tuition;TuitionAmount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "ACA-Fee By Stage".CalcFields("ACA-Fee By Stage"."Stage Charges");
                    TotalAmount:="ACA-Fee By Stage"."Break Down"+"ACA-Fee By Stage"."Stage Charges";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //TotalAmount:="Fee By Stage"."Break Down"+"Stage Charges".Amount;
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
        Fee_By_StageCaptionLbl: label 'Fee By Stage';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Tuition_PayableCaptionLbl: label 'Tuition Payable';
        TotalAmount: Decimal;
        TuitionAmount: Decimal;
}

