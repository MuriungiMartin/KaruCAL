#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 902 "Assembly Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Assembly Order.rdlc';
    Caption = 'Assembly Order';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Assembly Header";"Assembly Header")
        {
            DataItemTableView = sorting("Document Type","No.");
            RequestFilterFields = "No.","Item No.","Due Date";
            column(ReportForNavId_3252; 3252)
            {
            }
            column(No_AssemblyHeader;"No.")
            {
            }
            column(ItemNo_AssemblyHeader;"Item No.")
            {
                IncludeCaption = true;
            }
            column(Description_AssemblyHeader;Description)
            {
                IncludeCaption = true;
            }
            column(Quantity_AssemblyHeader;Quantity)
            {
                IncludeCaption = true;
            }
            column(QuantityToAssemble_AssemblyHeader;"Quantity to Assemble")
            {
                IncludeCaption = true;
            }
            column(UnitOfMeasureCode_AssemblyHeader;"Unit of Measure Code")
            {
            }
            column(DueDate_AssemblyHeader;Format("Due Date"))
            {
            }
            column(StartingDate_AssemblyHeader;Format("Starting Date"))
            {
            }
            column(EndingDate_AssemblyHeader;Format("Ending Date"))
            {
            }
            column(LocationCode_AssemblyHeader;"Location Code")
            {
                IncludeCaption = true;
            }
            column(BinCode_AssemblyHeader;"Bin Code")
            {
                IncludeCaption = true;
            }
            column(SalesDocNo;SalesDocNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            dataitem("Assembly Line";"Assembly Line")
            {
                DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                DataItemTableView = sorting("Document Type","Document No.","Line No.");
                column(ReportForNavId_6911; 6911)
                {
                }
                column(Type_AssemblyLine;Type)
                {
                    IncludeCaption = true;
                }
                column(No_AssemblyLine;"No.")
                {
                    IncludeCaption = true;
                }
                column(Description_AssemblyLine;Description)
                {
                    IncludeCaption = true;
                }
                column(VariantCode_AssemblyLine;"Variant Code")
                {
                }
                column(DueDate_AssemblyLine;Format("Due Date"))
                {
                }
                column(QuantityPer_AssemblyLine;"Quantity per")
                {
                    IncludeCaption = true;
                }
                column(Quantity_AssemblyLine;Quantity)
                {
                    IncludeCaption = true;
                }
                column(UnitOfMeasureCode_AssemblyLine;"Unit of Measure Code")
                {
                }
                column(LocationCode_AssemblyLine;"Location Code")
                {
                    IncludeCaption = true;
                }
                column(BinCode_AssemblyLine;"Bin Code")
                {
                    IncludeCaption = true;
                }
                column(QuantityToConsume_AssemblyLine;"Quantity to Consume")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnAfterGetRecord()
            var
                ATOLink: Record "Assemble-to-Order Link";
            begin
                Clear(SalesDocNo);
                if ATOLink.Get("Document Type","No.") then
                  SalesDocNo := ATOLink."Document No.";
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
        AssemblyOrderHeading = 'Assembly Order';
        AssemblyItemHeading = 'Assembly Item';
        BillOfMaterialHeading = 'Bill of Material';
        PageCaption = 'Page';
        OfCaption = 'of';
        OrderNoCaption = 'Order No.';
        QuantityAssembledCaption = 'Quantity Assembled';
        QuantityPickedCaption = 'Quantity Picked';
        QuantityConsumedCaption = 'Quantity Consumed';
        AssembleToOrderNoCaption = 'Asm. to Order No.';
        UnitOfMeasureCaption = 'Unit of Measure';
        VariantCaption = 'Variant';
        DueDateCaption = 'Due Date';
        StartingDateCaption = 'Starting Date';
        EndingDateCaption = 'Ending Date';
    }

    var
        SalesDocNo: Code[20];
}

