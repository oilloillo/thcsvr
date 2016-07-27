--天候-绯想天
function c200115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--[[cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(c200115.efilter1)
	c:RegisterEffect(e3)]]
	--[[indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c200115.val)
	c:RegisterEffect(e4)]]
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c200115.val)
	c:RegisterEffect(e1)
	--[[copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200115,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c200115.tg1)
	e1:SetOperation(c200115.op1)
	c:RegisterEffect(e1)]]
	--rm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(200115,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c200115.tg2)
	e1:SetOperation(c200115.op2)
	c:RegisterEffect(e1)
end--[[
function c200115.efilter1(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:IsSetCard(0x701)
end]]
function c200115.val(e,re)
	local x=re:GetHandler():GetOriginalCode()
	return ((x>=200001 and x<=200020) or (x==200115) or (x==200215) or (x==200302) or (x==25016))
end
function c200115.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local f=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if chk==0 then return f~=nil and f:IsFaceup() and not f:IsHasEffect(EFFECT_FORBIDDEN) end
	e:SetLabelObject(f)
end
function c200115.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and c:IsFaceup() and 
	tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() and not tc:IsHasEffect(EFFECT_FORBIDDEN) 
	then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	end
end
function c200115.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local f=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if chk==0 then return f~=nil and f:IsFaceup() and f:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	e:SetLabelObject(f)
end
function c200115.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and c:IsFaceup() and 
	tc:IsLocation(LOCATION_SZONE) and tc:IsAbleToRemove() then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			if tc and tc:IsLocation(LOCATION_REMOVED) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetRange(LOCATION_REMOVED)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetOperation(c200115.reop)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c200115.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end