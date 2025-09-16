#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51450 Dimensions
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Dimensions.rdlc';

    dataset
    {
        dataitem(Dimension;Dimension)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_2659; 2659)
            {
            }
            column(FORMAT_CurrReport_PAGENO_; Format(CurrReport.PageNo))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Dimension_Code;Code)
            {
            }
            column(Dimension_Name;Name)
            {
            }
            column(DimensionCaption;DimensionCaptionLbl)
            {
            }
            column(Dimension_CodeCaption;FieldCaption(Code))
            {
            }
            column(Dimension_NameCaption;FieldCaption(Name))
            {
            }
            dataitem("Dimension Value";"Dimension Value")
            {
                DataItemLink = "Dimension Code"=field(Code);
                column(ReportForNavId_6363; 6363)
                {
                }
                column(Dimension_Value_Code;Code)
                {
                }
                column(Dimension_Value_Name;Name)
                {
                }
                column(Dimension_Value__Dimension_Value_Type_;"Dimension Value Type")
                {
                }
                column(Dimension_Value_CodeCaption;FieldCaption(Code))
                {
                }
                column(Dimension_Value_NameCaption;FieldCaption(Name))
                {
                }
                column(Dimension_Value__Dimension_Value_Type_Caption;FieldCaption("Dimension Value Type"))
                {
                }
                column(Dimension_Value_Dimension_Code;"Dimension Code")
                {
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DimensionCaptionLbl: label 'Dimension';
}

