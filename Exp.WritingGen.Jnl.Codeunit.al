#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1276 "Exp. Writing Gen. Jnl."
{
    Permissions = TableData "Data Exch. Field"=rimd;
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        DataExchDef: Record "Data Exch. Def";
        DataExchField: Record "Data Exch. Field";
        OutputStream: OutStream;
    begin
        DataExchDef.Get("Data Exch. Def Code");
        DataExchDef.TestField("Reading/Writing XMLport");

        "File Content".CreateOutstream(OutputStream);
        DataExchField.SetRange("Data Exch. No.","Entry No.");
        Xmlport.Export(DataExchDef."Reading/Writing XMLport",OutputStream,DataExchField);

        DataExchField.DeleteAll(true);
    end;
}

