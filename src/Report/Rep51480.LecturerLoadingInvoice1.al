#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51480 "Lecturer Loading Invoice 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Loading Invoice 1.rdlc';

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = where("Document Type"=filter(Invoice));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Buy-from Vendor No.","No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompanyName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompAddress1;CompanyInformation."Address 2")
            {
            }
            column(CompPhonenO;CompanyInformation."Phone No.")
            {
            }
            column(CompPhoneNo2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompPic;CompanyInformation.Picture)
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompHome;CompanyInformation."Home Page")
            {
            }
            column(InvNo;"Purchase Header"."No.")
            {
            }
            column(ShipCustNo;"Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(ShipBill2No;"Purchase Header"."Pay-to Vendor No.")
            {
            }
            column(ShipBill2Name;"Purchase Header"."Pay-to Name")
            {
            }
            column(YourRef;"Purchase Header"."Your Reference")
            {
            }
            column(PostinDate;"Purchase Header"."Posting Date")
            {
            }
            column(PostingDes;"Purchase Header"."Posting Description")
            {
            }
            column(OrderNo;"Purchase Header"."Vendor Invoice No.")
            {
            }
            column(UserId1;UserId)
            {
            }
            column(OrderRoute;'')
            {
            }
            column(route;'')
            {
            }
            column(PhoneNo;vendor."Phone No.")
            {
            }
            column(PrevBalance;vendor.Balance)
            {
            }
            column(BalAfterInvoice;vendor.Balance)
            {
            }
            column(invNo2;"Purchase Header"."No.")
            {
            }
            column(invAmount;"Purchase Header".Amount)
            {
            }
            column(salesPerson;'')
            {
            }
            column(LocCode;'')
            {
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemLink = "Document No."=field("No.");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(seq;seq)
                {
                }
                column(LineNo;"Purchase Line"."Line No.")
                {
                }
                column(ItemType;"Purchase Line".Type)
                {
                }
                column(ItemNo;"Purchase Line"."No.")
                {
                }
                column(ItemDesc;"Purchase Line".Description)
                {
                }
                column(UnitOdMeasure;MILKOrderCustProdSource."Unit Cost")
                {
                }
                column(ItemQty;"Purchase Line".Quantity)
                {
                }
                column(unitPrice;"Purchase Line"."Direct Unit Cost")
                {
                }
                column(amnt;"Purchase Line"."Direct Unit Cost")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    seq:=seq+1;
                    if Item.Get("Purchase Line"."No.") then begin
                      end;


                    MILKOrderBatchLines.Reset;
                    MILKOrderBatchLines.SetRange(MILKOrderBatchLines."PV No.","Purchase Header"."No.");
                    if MILKOrderBatchLines.Find('-') then begin
                      MILKOrderCustProdSource.Reset;
                      MILKOrderCustProdSource.SetRange(MILKOrderCustProdSource.Semester,MILKOrderBatchLines."Semester Code");
                      MILKOrderCustProdSource.SetRange(MILKOrderCustProdSource.Lecturer,"Purchase Header"."Buy-from Vendor No.");
                     // MILKOrderCustProdSource.SETRANGE(MILKOrderCustProdSource.Stage,"Sales Invoice Line"."No.");
                      if MILKOrderCustProdSource.Find('-') then begin
                        end;
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(seq);
                vendor.Reset;
                vendor.SetRange(vendor."No.","Purchase Header"."Buy-from Vendor No.");
                if vendor.Find('-') then begin
                 // Vendor.SETFILTER("Date Filter",'..%1',CALCDATE('-1D',"Sales Invoice Header"."Posting Date"));
                  vendor.CalcFields(Balance);
                  end;

                PurchaseInvoiceHeader.Reset;
                PurchaseInvoiceHeader.SetRange(PurchaseInvoiceHeader."No.","Purchase Header"."No.");
                if PurchaseInvoiceHeader.Find('-') then begin
                  PurchaseInvoiceHeader.CalcFields(PurchaseInvoiceHeader.Amount);
                  end;
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

    trigger OnInitReport()
    begin
        if CompanyInformation.Get() then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        CompanyInformation: Record "Company Information";
        seq: Integer;
        vendor: Record Vendor;
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        Item: Record Item;
        MILKOrderBatchLines: Record UnknownRecord65201;
        MILKOrderCustProdSource: Record UnknownRecord65202;
}

