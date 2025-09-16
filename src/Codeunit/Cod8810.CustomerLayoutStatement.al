#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8810 "Customer Layout - Statement"
{
    // // Wrapper codeunit to call 8800 - allows menus and objects to invoke a CU directly to get the per-customer
    // // layout support for statements.


    trigger OnRun()
    var
        Customer: Record Customer;
        RecRef: RecordRef;
    begin
        RecRef.Open(Database::Customer);
        CustomLayoutReporting.SetOutputFileBaseName(StatementFileNameTxt);
        CustomLayoutReporting.ProcessReportForData(ReportSelections.Usage::"C.Statement",RecRef,Customer.FieldName("No."),
          Database::Customer,Customer.FieldName("No."),true);
    end;

    var
        ReportSelections: Record "Report Selections";
        CustomLayoutReporting: Codeunit "Custom Layout Reporting";
        StatementFileNameTxt: label 'Statement', Comment='Shortened form of ''Customer Statement''';
}

