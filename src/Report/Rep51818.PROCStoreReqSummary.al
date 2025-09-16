#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51818 "PROC-Store Req. Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PROC-Store Req. Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61399;UnknownTable61399)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(compName;info.Name)
            {
            }
            column(addr;info.Address+', '+info.City)
            {
            }
            column(phone;info."Phone No.")
            {
            }
            column(email;info."E-Mail")
            {
            }
            column(pics;info.Picture)
            {
            }
            column(No;"PROC-Store Requistion Header"."No.")
            {
            }
            column(ReqDate;"PROC-Store Requistion Header"."Request date")
            {
            }
            column(desc;"PROC-Store Requistion Header"."Request Description")
            {
            }
            column(college;"PROC-Store Requistion Header"."Global Dimension 1 Code")
            {
            }
            column(dept;DimVal.Code+' : '+DimVal.Name)
            {
            }
            column(reqId;"PROC-Store Requistion Header"."User ID")
            {
            }
            column(Tamount;"PROC-Store Requistion Header".TotalAmount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal.Code,"PROC-Store Requistion Header"."Shortcut Dimension 2 Code");
                    if DimVal.Find('-') then begin
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
              info.Reset;
              if info.Find('-') then begin
                info.CalcFields(info.Picture);
              end;
    end;

    var
        info: Record "Company Information";
        DimVal: Record "Dimension Value";
}

