/// Vertical density of a [ProTable]. Mirrors the "Compact / Standard /
/// Comfortable" toggle that ERP / CRM products like Zoho and Odoo expose.
///
/// Applied to [ProTableTheme] via `theme.applyDensity(...)`. You can also
/// pass it directly through [ProTable.density] — the table will scale row
/// height, header height and cell padding accordingly.
enum ProTableDensity { compact, standard, comfortable }
