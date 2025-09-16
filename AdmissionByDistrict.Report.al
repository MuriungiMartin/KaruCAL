#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51362 "Admission By District"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Admission By District.rdlc';

    dataset
    {
        dataitem(UnknownTable61365;UnknownTable61365)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_6493; 6493)
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(Application_Setup_County_Code;Code)
            {
            }
            column(Application_Setup_County__Application_Setup_County__Description;"ACA-Applic. Setup County".Description)
            {
            }
            column(IntC;IntC)
            {
            }
            column(GIntC;GIntC)
            {
            }
            column(STUDENTS_STATISTICS_PER_DISTRICTCaption;STUDENTS_STATISTICS_PER_DISTRICTCaptionLbl)
            {
            }
            column(OFFICE_OF_THE_DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaption;OFFICE_OF_THE_DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaptionLbl)
            {
            }
            column(SERIAL_NO_Caption;SERIAL_NO_CaptionLbl)
            {
            }
            column(DISTRICTCaption;DISTRICTCaptionLbl)
            {
            }
            column(TOTALSCaption;TOTALSCaptionLbl)
            {
            }
            column(GRAND_TOTALSCaption;GRAND_TOTALSCaptionLbl)
            {
            }
            column(Number;"ACA-Applic. Setup County"."No. of Students")
            {
            }
            dataitem(UnknownTable61372;UnknownTable61372)
            {
                DataItemLink = "Home District"=field(Code);
                column(ReportForNavId_3773; 3773)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IntC:=IntC +1;
                    GIntC:=GIntC +1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IntC:=0;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        IntC: Integer;
        GIntC: Integer;
        STUDENTS_STATISTICS_PER_DISTRICTCaptionLbl: label 'STUDENTS STATISTICS PER DISTRICT';
        OFFICE_OF_THE_DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaptionLbl: label 'OFFICE OF THE DEPUTY REGISTRAR, ACADEMIC AFFAIRS';
        SERIAL_NO_CaptionLbl: label 'SERIAL NO.';
        DISTRICTCaptionLbl: label 'DISTRICT';
        TOTALSCaptionLbl: label 'TOTALS';
        GRAND_TOTALSCaptionLbl: label 'GRAND TOTALS';
}

