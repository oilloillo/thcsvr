--风神少女✿蕾米莉亚·斯卡雷特
function c19015.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x814),aux.FilterBoolFunction(Card.IsSetCard,0x125),true)

		--direct atk
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_DIRECT_ATTACK)
		c:RegisterEffect(e6)

			--hurt
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EVENT_BATTLE_DAMAGE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetOperation(c19015.dam)
			c:RegisterEffect(e1)

			--recover
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(25171,0))
			e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCountLimit(1)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetLabelObject(e1)
			e2:SetTarget(c19015.tdtg)
			e2:SetOperation(c19015.tdop)
			c:RegisterEffect(e2)

		--act qp in hand
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(LOCATION_HAND,0)
		e3:SetCountLimit(1)
		c:RegisterEffect(e3)

end


function c19015.dam(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	e:GetHandler():RegisterFlagEffect(19015,RESET_EVENT+0x1fe0000,0,0)
	e:SetLabel(ev)
end


function c19015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rev=e:GetLabelObject():GetLabel()
	if chk==0 then return c:GetFlagEffect(19015)>0 and c:IsAbleToDeck() and rev>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rev)
end


function c19015.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rev=e:GetLabelObject():GetLabel()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.Recover(tp,rev,REASON_EFFECT)
	end
end

