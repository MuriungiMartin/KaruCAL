#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51853 "Bid Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bid Analysis.rdlc';

    dataset
    {
        dataitem(UnknownTable61550;UnknownTable61550)
        {
            RequestFilterFields = "RFQ No.";
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(RFQNo_BidAnalysis;"PROC-Bid Analysis"."RFQ No.")
            {
            }
            column(QuoteNo_BidAnalysis;"PROC-Bid Analysis"."Quote No.")
            {
            }
            column(VendorNo_BidAnalysis;"PROC-Bid Analysis"."Vendor No.")
            {
            }
            column(ItemNo_BidAnalysis;"PROC-Bid Analysis"."Item No.")
            {
            }
            column(Description_BidAnalysis;"PROC-Bid Analysis".Description)
            {
            }
            column(Quantity_BidAnalysis;"PROC-Bid Analysis".Quantity)
            {
            }
            column(UnitOfMeasure_BidAnalysis;"PROC-Bid Analysis"."Unit Of Measure")
            {
            }
            column(Amount_BidAnalysis;"PROC-Bid Analysis".Amount)
            {
            }
            column(LineAmount_BidAnalysis;"PROC-Bid Analysis"."Line Amount")
            {
            }
            column(RFQLineNo_BidAnalysis;"PROC-Bid Analysis"."RFQ Line No.")
            {
            }
            column(CompanyInfoName;CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress;CompanyInfo.Address)
            {
            }
            column(CompanyInfoPicture;CompanyInfo.Picture)
            {
            }
            column(LastDirectCost_BidAnalysis;"PROC-Bid Analysis"."Last Direct Cost")
            {
            }
            column(Total_BidAnalysis;"PROC-Bid Analysis".Total)
            {
            }
            column(Name_Vendor;VendorName)
            {
            }
            column(SelectedVendor;SelectedVendor)
            {
            }
            column(SelectedPrice;SelectedPrice)
            {
            }
            column(TotalPrice;TotalPrice)
            {
            }
            column(SelectedRemarks;SelectedRemarks)
            {
            }
            column(SelectedVendor_Text001;StrSubstNo(Text001,SelectedVendor))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Vendor.Get("PROC-Bid Analysis"."Vendor No.") then
                VendorName:=Vendor.Name;
                BidAnalysis.Reset;
                BidAnalysis.SetRange("RFQ No.","RFQ No.");
                BidAnalysis.SetRange("RFQ Line No.","RFQ Line No.");
                BidAnalysis.SetCurrentkey(BidAnalysis."RFQ No.",BidAnalysis."RFQ Line No.",BidAnalysis.Amount);
                if BidAnalysis.FindFirst then
                begin
                  Vendor.Get(BidAnalysis."Vendor No.");
                  SelectedVendor:=Vendor.Name;
                  SelectedPrice:=BidAnalysis.Amount;
                  TotalPrice:=BidAnalysis.Amount*BidAnalysis.Quantity;
                  SelectedRemarks:= BidAnalysis.Remarks;
                end
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
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        BidAnalysis: Record UnknownRecord61550;
        SelectedVendor: Text;
        SelectedPrice: Decimal;
        TotalPrice: Decimal;
        VendorName: Text;
        SelectedRemarks: Text;
        Text001: label ' Based on Price,  %1  has been Recommended on this bid analysis';
}

