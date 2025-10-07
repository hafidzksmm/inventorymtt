<template>
  <div>

    <base-header class="pb-6 pb-8 pt-5 pt-md-8 bg-gradient-danger">
      <!-- Card stats -->
    </base-header>

    <!--Charts-->

  </div>
</template>
<script>


  // Tables
  import SocialTrafficTable from './Dashboard/SocialTrafficTable';
  import PageVisitsTable from './Dashboard/PageVisitsTable';

  export default {
    components: {
      PageVisitsTable,
      SocialTrafficTable
    },
    mounted() {
      this.initBigChart(0);
    }
  };
</script>
<style>
.el-table .cell{
  padding-left: 0px;
  padding-right: 0px;
}
</style>
