#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70070 "Customer Photo Sync"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Cust;Customer)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                
                /*
                StringCounts:=StringCounts+1;
                Cust.Countings:=StringCounts;
                Cust.MODIFY;
                */
                if impexp=Impexp::Export then  begin
                Cust.CalcFields(Cust.Picture);
                Cust.CalcFields(Cust."Barcode Picture");
                if Cust.Picture.Hasvalue then begin
                  Cust.Picture.Export('D:\Cust_Images\'+Format(Cust.Countings)+'_Image.JPG');
                end;
                
                if Cust."Barcode Picture".Hasvalue then begin
                  Cust."Barcode Picture".Export('D:\Cust_Images\'+Format(Cust.Countings)+'_Barcode.JPG');
                end;
                
                end else begin
                  Clear(Cust.Picture);
                  Clear(Cust."Barcode Picture");
                  // Image
                if Exists ('D:\Cust_Images\'+Format(Cust.Countings)+'_Image.JPG') then begin
                  Cust.Picture.Import('D:\Cust_Images\'+Format(Cust.Countings)+'_Image.JPG');
                  Cust.Modify;
                end;
                // Barcode
                if Exists ('D:\Cust_Images\'+Format(Cust.Countings)+'_Barcode.JPG') then begin
                  Cust."Barcode Picture".Import('D:\Cust_Images\'+Format(Cust.Countings)+'_Barcode.JPG');
                  Cust.Modify;
                end;
                  end;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(expimp;impexp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import/Export';
                    OptionCaption = ' ,Import,Export';
                }
            }
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
        //CLEAR(StringCounts);
    end;

    trigger OnPreReport()
    begin
        if impexp=Impexp::" " then Error('Specify the Direction!');
    end;

    var
        impexp: Option " ",Import,Export;
        NewstdNo: Code[20];
        StringCounts: Integer;
}

