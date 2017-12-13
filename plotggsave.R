#### Saving plots ####


ggsave(filename='weighted average size by country.pdf', 
       plot=plot_avg_size, 
       path = graphs_dir,
       device='pdf',
       height=8, width=14.16, units='in')

ggsave(filename='weighted average size sectoral.pdf', 
       plot=plot_avg_size, 
       path = graphs_dir,
       device='pdf',
       height=8, width=14.16, units='in')

# ggsave(filename='size 1 dynamics.pdf',
#        plot=plot_avg_sz1,
#        path=graphs_dir,
#        device='pdf',
#        height=8, width=14.16, units='in')

ggsave(filename='Sizes relative share.pdf',
       plot=plot_relshare_size,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')

ggsave(filename='Employment relative shares by size.pdf',
       plot=plot_relshare_emp,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')

ggsave(filename = 'Labour cost per employee levels.pdf',
       plot=plot_lc_l,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')

ggsave(filename = 'Labour cost per employee evolution.pdf',
       plot=plot_lc_l_norm,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')

ggsave(filename='Share of finconstr firms from BS.pdf',
       plot=plot_safe,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')

ggsave(filename='Share of self-reporting finconstr.pdf',
       plot=plot_absconstr,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')

ggsave(filename='Unit labour cost dynamics.pdf',
       plot=plot_ulc,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')

ggsave(filename='Financial gap.pdf',
       plot=plot_fingap,
       path=graphs_dir,
       device='pdf',
       height=8, width=14.6, units='in')