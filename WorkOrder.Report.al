#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 752 "Work Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Work Order.rdlc';
    Caption = 'Work Order';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
            RequestFilterFields = "No.","Sell-to Customer No.";
            RequestFilterHeading = 'Sales Order';
            column(ReportForNavId_6640; 6640)
            {
            }
            dataitem(PageLoop;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_6455; 6455)
                {
                }
                column(No1_SalesHeader;"Sales Header"."No.")
                {
                }
                column(ShipmentDate_SalesHeader;Format("Sales Header"."Shipment Date"))
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(CustAddr1;CustAddr[1])
                {
                }
                column(CustAddr2;CustAddr[2])
                {
                }
                column(CustAddr3;CustAddr[3])
                {
                }
                column(CustAddr4;CustAddr[4])
                {
                }
                column(CustAddr5;CustAddr[5])
                {
                }
                column(CustAddr6;CustAddr[6])
                {
                }
                column(CustAddr7;CustAddr[7])
                {
                }
                column(CustAddr8;CustAddr[8])
                {
                }
                column(ShipmentDateCaption;ShipmentDateCaptionLbl)
                {
                }
                column(SalesOrderNoCaption;SalesOrderNoCaptionLbl)
                {
                }
                column(PageNoCaption;PageNoCaptionLbl)
                {
                }
                column(WorkOrderCaption;WorkOrderCaptionLbl)
                {
                }
                dataitem("Sales Line";"Sales Line")
                {
                    DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = sorting("Document Type","Document No.","Line No.");
                    column(ReportForNavId_2844; 2844)
                    {
                    }
                    column(No_SalesLine;"No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_SalesLine;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_SalesLine;Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitofMeasure_SalesLine;"Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
                    column(Type_SalesLine;Type)
                    {
                        IncludeCaption = true;
                    }
                    column(QtyworkPostSalesOrderCptn;QtyworkPostSalesOrderCptnLbl)
                    {
                    }
                    column(QuantityUsedCaption;QuantityUsedCaptionLbl)
                    {
                    }
                    column(UnitofMeasureCaption;UnitofMeasureCaptionLbl)
                    {
                    }
                }
                dataitem("Sales Comment Line";"Sales Comment Line")
                {
                    DataItemLink = "Document Type"=field("Document Type"),"No."=field("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = where("Document Line No."=const(0));
                    column(ReportForNavId_8541; 8541)
                    {
                    }
                    column(Date_SalesCommentLine;Format(Date))
                    {
                    }
                    column(Code_SalesCommentLine;Code)
                    {
                        IncludeCaption = true;
                    }
                    column(Comment_SalesCommentLine;Comment)
                    {
                        IncludeCaption = true;
                    }
                    column(CommentsCaption;CommentsCaptionLbl)
                    {
                    }
                    column(SalesCommentLineDtCptn;SalesCommentLineDtCptnLbl)
                    {
                    }
                }
                dataitem("Extra Lines";"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_2249; 2249)
                    {
                    }
                    column(NoCaption;NoCaptionLbl)
                    {
                    }
                    column(DescriptionCaption;DescriptionCaptionLbl)
                    {
                    }
                    column(QuantityCaption;QuantityCaptionLbl)
                    {
                    }
                    column(UnitofMeasureCaptionControl33;UnitofMeasureCaptionControl33Lbl)
                    {
                    }
                    column(DateCaption;DateCaptionLbl)
                    {
                    }
                    column(workPostdItemorResJnlCptn;workPostdItemorResJnlCptnLbl)
                    {
                    }
                    column(TypeCaption;TypeCaptionLbl)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.SalesHeaderBillTo(CustAddr,"Sales Header");
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
        FormatAddr: Codeunit "Format Address";
        CustAddr: array [8] of Text[50];
        ShipmentDateCaptionLbl: label 'Shipment Date';
        SalesOrderNoCaptionLbl: label 'Sales Order No.';
        PageNoCaptionLbl: label 'Page';
        WorkOrderCaptionLbl: label 'Work Order';
        QtyworkPostSalesOrderCptnLbl: label 'Quantity used during work (Posted with the Sales Order)';
        QuantityUsedCaptionLbl: label 'Quantity Used';
        UnitofMeasureCaptionLbl: label 'Unit of Measure';
        CommentsCaptionLbl: label 'Comments';
        SalesCommentLineDtCptnLbl: label 'Date';
        NoCaptionLbl: label 'No.';
        DescriptionCaptionLbl: label 'Description';
        QuantityCaptionLbl: label 'Quantity';
        UnitofMeasureCaptionControl33Lbl: label 'Unit of Measure';
        DateCaptionLbl: label 'Date';
        workPostdItemorResJnlCptnLbl: label 'Extra Item/Resource used during work (Posted with Item or Resource Journals)';
        TypeCaptionLbl: label 'Type';
}

