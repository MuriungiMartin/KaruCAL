#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51203 "Programme Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Programme Units.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_1410; 1410)
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
            column(Programme_Code;Code)
            {
            }
            column(Programme_Code_Control1102756011;Code)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_Code_Control1102756011Caption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
                column(ReportForNavId_1; 1)
                {
                }
                column(StaGeCode;"ACA-Programme Stages".Code)
                {
                }
                column(StageDesc;"ACA-Programme Stages".Description)
                {
                }
                dataitem(UnknownTable61517;UnknownTable61517)
                {
                    DataItemLink = "Programme Code"=field("Programme Code"),"Stage Code"=field(Code);
                    column(ReportForNavId_2955; 2955)
                    {
                    }
                    column(UnitCode;"ACA-Units/Subjects".Code)
                    {
                    }
                    column(UnitDesc;"ACA-Units/Subjects".Desription)
                    {
                    }
                    column(UnitCreditHrs;"ACA-Units/Subjects"."Credit Hours")
                    {
                    }
                }
            }

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

    trigger OnPreReport()
    begin
           info.Reset;
           if info.Find('-') then info.CalcFields(Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        ProgrammeCaptionLbl: label 'Programme';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        info: Record "Company Information";
}

