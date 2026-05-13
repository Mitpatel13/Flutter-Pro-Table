/// How [ProTable] renders the loading state.
///
/// * [ProLoadingStyle.spinner] — a centered [CircularProgressIndicator].
/// * [ProLoadingStyle.skeleton] — animated placeholder rows (shimmer-like)
///   that match the column widths. This feels closer to how ERP tables in
///   Zoho / Linear / Notion render their loading state.
enum ProLoadingStyle { spinner, skeleton }
