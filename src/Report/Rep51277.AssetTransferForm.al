#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51277 "Asset Transfer Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Asset Transfer Form.rdlc';

    dataset
    {
        dataitem(UnknownTable69262;UnknownTable69262)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_HRAssetTransferLines;"HR Asset Transfer Lines"."No.")
            {
            }
            column(AssetNo_HRAssetTransferLines;"HR Asset Transfer Lines"."Asset No.")
            {
            }
            column(AssetBarCode_HRAssetTransferLines;"HR Asset Transfer Lines"."Asset Bar Code")
            {
            }
            column(AssetDescription_HRAssetTransferLines;"HR Asset Transfer Lines"."Asset Description")
            {
            }
            column(FALocation_HRAssetTransferLines;"HR Asset Transfer Lines"."FA Location")
            {
            }
            column(ResponsibleEmployeeCode_HRAssetTransferLines;"HR Asset Transfer Lines"."Responsible Employee Code")
            {
            }
            column(AssetSerialNo_HRAssetTransferLines;"HR Asset Transfer Lines"."Asset Serial No")
            {
            }
            column(EmployeeName_HRAssetTransferLines;"HR Asset Transfer Lines"."Employee Name")
            {
            }
            column(ReasonforTransfer_HRAssetTransferLines;"HR Asset Transfer Lines"."Reason for Transfer")
            {
            }
            column(NewResponsibleEmployeeCode_HRAssetTransferLines;"HR Asset Transfer Lines"."New Responsible Employee Code")
            {
            }
            column(NewEmployeeName_HRAssetTransferLines;"HR Asset Transfer Lines"."New Employee Name")
            {
            }
            column(GlobalDimension1Code_HRAssetTransferLines;"HR Asset Transfer Lines"."Global Dimension 1 Code")
            {
            }
            column(NewGlobalDimension1Code_HRAssetTransferLines;"HR Asset Transfer Lines"."New Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_HRAssetTransferLines;"HR Asset Transfer Lines"."Global Dimension 2 Code")
            {
            }
            column(NewGlobalDimension2Code_HRAssetTransferLines;"HR Asset Transfer Lines"."New Global Dimension 2 Code")
            {
            }
            column(GlobalDimension3Code_HRAssetTransferLines;"HR Asset Transfer Lines"."Global Dimension 3 Code")
            {
            }
            column(NewGlobalDimension3Code_HRAssetTransferLines;"HR Asset Transfer Lines"."New Global Dimension 3 Code")
            {
            }
            column(Dimension1Name_HRAssetTransferLines;"HR Asset Transfer Lines"."Dimension 1 Name")
            {
            }
            column(NewDimension1Name_HRAssetTransferLines;"HR Asset Transfer Lines"."New  Dimension 1 Name")
            {
            }
            column(Dimension2Name_HRAssetTransferLines;"HR Asset Transfer Lines"."Dimension 2 Name")
            {
            }
            column(NewDimension2Name_HRAssetTransferLines;"HR Asset Transfer Lines"."New  Dimension 2 Name")
            {
            }
            column(Dimension3Name_HRAssetTransferLines;"HR Asset Transfer Lines"."Dimension 3 Name")
            {
            }
            column(NewDimension3Name_HRAssetTransferLines;"HR Asset Transfer Lines"."New  Dimension 3 Name")
            {
            }
            column(IsAssetExpectedBack_HRAssetTransferLines;"HR Asset Transfer Lines"."Is Asset Expected Back?")
            {
            }
            column(DurationofTransfer_HRAssetTransferLines;"HR Asset Transfer Lines"."Duration of Transfer")
            {
            }
            column(NewAssetLocation_HRAssetTransferLines;"HR Asset Transfer Lines"."New Asset Location")
            {
            }
            column(BookValue_HRAssetTransferLines;"HR Asset Transfer Lines"."Book Value")
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
}

