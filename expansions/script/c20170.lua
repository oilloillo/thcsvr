 
--人符「现世斩」
function c20170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_SSET)
	e1:SetTarget(c20170.target)
	e1:SetOperation(c20170.activate)
	c:RegisterEffect(e1)
end
function c20170.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c20170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c20170.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20170.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20170.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c20170.limit(g:GetFirst()))
	if Duel.GetCurrentChain()<3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c20170.operation)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		e:SetLabelObject(e1)
	end
end
function c20170.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c20170.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	if e:GetLabelObject() then
		local ct=e:GetLabelObject():GetLabel()
		if ct>0 then
			Duel.Damage(1-tp,ct*200,REASON_EFFECT)
		end
		e:GetLabelObject():Reset()
	end
end
function c20170.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() then return end
	local ct=Duel.GetCurrentChain()
	e:SetLabel(ct)
end
