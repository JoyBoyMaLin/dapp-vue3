<script lang="ts">
import { defineComponent } from "vue";
import useMetaMask from "@/composables/metamask";

export default defineComponent({
  name: "CoinToss",
  setup() {
    const {etherBalance, connectError} = useMetaMask();
    return {
      etherBalance,
      connectError
    };
  },
});
</script>

<template>
  <div class="text-center text-gray-600">
    <p class="text-red-600">{{ connectError }}</p>
    <p class="text-2xl">Coin Toss</p>
    <p>ETH: {{ etherBalance }}</p>
  </div>

  <div class="grid place-items-center">
    <div class="w-11/12 p-12 bg-white sm:w-8/12 md:w-1/2 lg:w-5/12">
      <div class="flex justify-between gap-3">
        <span class="w-full">
          <label
              class="block text-xs font-semibold text-gray-600 uppercase"
              for="Greeting"
          >Greeting</label>
          <input
              id="Greeting"
              v-model="greetInput"
              class="block w-full p-3 mt-2 text-gray-700 bg-gray-100 appearance-none focus:outline-none focus:bg-gray-300 focus:shadow-inner"
              name="Greeting"
              placeholder="Hello World"
              required
              type="text"
              @keyup.enter="setGreetingBtn()"
          >
        </span>
      </div>
      <button
          :disabled="isPending"
          class="btn w-full my-4"
          @click="setGreetingBtn()"
      >{{ isPending ? "pending" : "setGreeting" }}
      </button>
    </div>
  </div>
  <p class="p-10 text-center text-red-600"> {{ errMsg }} </p>

</template>