#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51859 "HRM Export Photoz"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("HR Employee C";UnknownTable61188)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if impexp=Impexp::Export then  begin
                "HR Employee C".CalcFields("HR Employee C".Picture);
                "HR Employee C".CalcFields("HR Employee C"."Barcode Picture");
                if "HR Employee C".Picture.Hasvalue then begin
                  "HR Employee C".Picture.Export('D:\Images_HR\'+"HR Employee C"."No."+'_Image.JPG');
                end;

                if "HR Employee C"."Barcode Picture".Hasvalue then begin
                  "HR Employee C"."Barcode Picture".Export('D:\Images_HR\'+"HR Employee C"."No."+'_Barcode.JPG');
                end;

                end else begin
                  Clear("HR Employee C".Picture);
                  Clear("HR Employee C"."Barcode Picture");
                  // Image
                if Exists ('D:\Images_HR\'+"HR Employee C"."No."+'_Image.JPG') then begin
                  "HR Employee C".Picture.Import('D:\Images_HR\'+"HR Employee C"."No."+'_Image.JPG');
                  "HR Employee C".Modify;
                end;
                // Barcode
                if Exists ('D:\Images_HR\'+"HR Employee C"."No."+'_Barcode.JPG') then begin
                  "HR Employee C"."Barcode Picture".Import('D:\Images_HR\'+"HR Employee C"."No."+'_Barcode.JPG');
                  "HR Employee C".Modify;
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

    trigger OnPreReport()
    begin
        if impexp=Impexp::" " then Error('Specify the Direction!');
    end;

    var
        impexp: Option " ",Import,Export;
}

